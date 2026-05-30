// supabase/functions/agent-chat/index.ts

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

type ChatRole = "user" | "assistant";

type ChatMessage = {
  role: ChatRole;
  text: string;
};

type AgentRequest = {
  message: string;
  history?: ChatMessage[];
  agent?: "love_assistant";
};

type AgentResponse = {
  text: string;
  provider: string;
  model: string;
};

type AgentProvider = {
  name: string;
  model: string;
  generate(input: {
    systemPrompt: string;
    message: string;
    history: ChatMessage[];
  }): Promise<AgentResponse>;
};

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return json({ error: "Method not allowed" }, 405);
    }

    const body = await req.json() as AgentRequest;

    if (!body.message || typeof body.message !== "string") {
      return json({ error: "Missing message" }, 400);
    }

    const provider = createProvider();

    const result = await provider.generate({
      systemPrompt: getSystemPrompt(body.agent ?? "love_assistant"),
      message: body.message,
      history: sanitizeHistory(body.history ?? []),
    });

    return json(result);
  } catch (error) {
    return json({ error: String(error) }, 500);
  }
});

function createProvider(): AgentProvider {
  const provider = Deno.env.get("AGENT_PROVIDER") ?? "gemini";

  switch (provider) {
    case "gemini":
      return new GeminiProvider();
    default:
      throw new Error(`Unsupported AGENT_PROVIDER: ${provider}`);
  }
}

class GeminiProvider implements AgentProvider {
  name = "gemini";
  model = Deno.env.get("GEMINI_MODEL") ?? "gemini-3.5-flash";

  async generate(input: {
    systemPrompt: string;
    message: string;
    history: ChatMessage[];
  }): Promise<AgentResponse> {
    const apiKey = Deno.env.get("GEMINI_API_KEY");

    if (!apiKey) {
      throw new Error("Missing GEMINI_API_KEY");
    }

    const contents = [
      ...input.history.map((item) => ({
        role: item.role === "assistant" ? "model" : "user",
        parts: [{ text: item.text }],
      })),
      {
        role: "user",
        parts: [{ text: input.message }],
      },
    ];

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${this.model}:generateContent`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey,
        },
        body: JSON.stringify({
          systemInstruction: {
            parts: [{ text: input.systemPrompt }],
          },
          contents,
          generationConfig: {
            temperature: 0.55,
            topP: 0.9,
            maxOutputTokens: 1200,
          },
        }),
      },
    );

    const data = await response.json();

    if (!response.ok) {
      throw new Error(`Gemini failed: ${JSON.stringify(data)}`);
    }

    const text =
      data?.candidates?.[0]?.content?.parts
        ?.map((part: { text?: string }) => part.text ?? "")
        .join("") ?? "";

    return {
      text,
      provider: this.name,
      model: this.model,
    };
  }
}

function getSystemPrompt(agent: "love_assistant"): string {
  switch (agent) {
    case "love_assistant":
      return `
You are BetterHalf, a warm, practical relationship assistant for busy people who care about their partner but sometimes struggle to consistently show it.

Your job is to help the user turn care into small, thoughtful actions.

Core positioning:
- Do not frame the product as replacing love, outsourcing romance, or automating affection.
- Frame every suggestion as helping the user act on care that is already there.
- Never shame the user, guilt them, or imply they are a bad partner.
- Be warm, human, emotionally intelligent, lightly playful, and practical.
- Avoid therapy-speak, corporate wording, cheesy romance clichés, and generic AI-assistant phrasing.

Interaction model:
- This product is not a chatbot.
- Prefer artifact-style outputs: message drafts, date ideas, gift ideas, reminders, tiny plans, occasion prep, or partner-profile notes.
- Do not create long back-and-forth conversations unless absolutely necessary.
- When information is missing, ask for the minimum missing detail needed, or give a useful first draft with clear assumptions.
- Keep answers concise and easy to act on.

Useful output types:
- Message draft: ready-to-send text, plus 1-2 alternate tones if helpful.
- Date plan: simple, specific plan with timing, vibe, and why it fits.
- Gift idea: concrete idea, why it fits, and a fallback option.
- Reminder/nudge: short context line plus suggested action.
- Partner profile note: structured observation that could improve future suggestions.
- Occasion prep: short checklist and one immediate next action.

Partner profile context may include:
- Partner name
- Pronouns
- Birthday
- Love languages
- Tone of voice
- Hobbies
- Favorite foods
- Gift preferences
- Relationship type
- Anniversary

Safety and boundaries:
- Do not give medical, legal, or financial advice.
- Do not manipulate, deceive, love-bomb, or suggest messages that pressure the partner.
- Do not write messages that hide important truth, fake feelings, or impersonate the user in a dishonest way.
- Do not encourage stalking, surveillance, jealousy testing, or checking a partner's private accounts.
- For serious conflict, abuse, threats, coercion, or fear, gently recommend seeking trusted human support or local emergency help.
- If the user asks for something harmful, controlling, or deceptive, refuse briefly and offer a healthier alternative.

Style:
- Use plain language.
- Be specific.
- Prefer short sections.
- Make the user feel relieved and capable.
- The best answer usually gives them one thoughtful thing they can do right now.
`.trim();
  }
}

function sanitizeHistory(history: ChatMessage[]): ChatMessage[] {
  return history
    .filter((item) =>
      (item.role === "user" || item.role === "assistant") &&
      typeof item.text === "string" &&
      item.text.trim().length > 0
    )
    .slice(-20);
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "Content-Type": "application/json",
    },
  });
}