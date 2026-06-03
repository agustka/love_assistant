### Layout changes

#### First wizard page
- Keep the existing first wizard page structure and primary onboarding action.
- Add a secondary login prompt in the bottom action area, below the primary wizard action.
- The prompt should read "Already have an account?" followed by a tappable "Log in" action.
- The login action should be styled as a text link, not as a full-width button.
- The primary wizard action should remain visually dominant.
- The login prompt should wrap cleanly on small screens and with large accessibility text.

#### Post-wizard account option page
- Keep the existing account option page structure and primary sign-up action.
- Replace the current full-width login-style secondary action with the same secondary prompt-link pattern used on the first wizard page.
- The prompt should read "Already have an account?" followed by a tappable "Log in" action.
- The sign-up action should remain visually dominant.
- The login prompt should sit below the primary action in the bottom action area.

#### Login page
- Add a login page shell that communicates an under-construction state.
- The page should use the app's normal page structure, with a standard way to go back.
- The page should show a concise title and message explaining that login is not ready yet.
- Do not show email, password, forgot-password, Apple, Google, or submit controls on this page.

#### States
- Default: the login affordance is visible and tappable from both entry points.
- Under construction: the login page shows only the unavailable-login state and back navigation.
- Back navigation: returning from the login page restores the page the user came from.

#### Open questions
- None.
