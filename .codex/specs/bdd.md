### Work Type
feature

### User story
As a user who already has an account,
I want a clear way to log in from onboarding and the post-wizard account page,
so that I do not have to start sign-up again.

#### Acceptance criteria

**Login affordance on the first wizard page**
- Given the user opens the first wizard page
- When the first wizard page is displayed
- Then a secondary login affordance should be visible with the prompt "Already have an account?" and the action "Log in"
- And the primary wizard action should remain the most prominent action on the page
- And the login affordance should not appear as a second full-width primary button

**Login affordance navigates from the first wizard page**
- Given the user is on the first wizard page
- When the user taps the "Log in" action
- Then the user should be taken to the login page

**Login affordance on the post-wizard account page**
- Given the user completes the wizard and reaches the account option page
- When the account option page is displayed
- Then a secondary login affordance should be visible with the prompt "Already have an account?" and the action "Log in"
- And the sign-up action should remain the most prominent action on the page

**Login affordance navigates from the post-wizard account page**
- Given the user is on the account option page after the wizard
- When the user taps the "Log in" action
- Then the user should be taken to the login page

**Login page under construction state**
- Given the user navigates to the login page
- When the login page opens
- Then an under-construction state should be visible
- And the page should make clear that login is not ready yet
- And the user should have a way to go back to the previous page

**Returning from the under-construction login page**
- Given the user is on the under-construction login page
- When the user goes back
- Then they should return to the page they came from

#### Out of scope
- Real login form submission
- Email and password validation on the login page
- Forgot-password behavior
- Social login behavior
- Session creation or authentication state changes
- Backend or local authentication contract changes

#### Testing directives
- Add UAT coverage for navigation from the first wizard page to the under-construction login page.
- Add UAT coverage for navigation from the post-wizard account page to the under-construction login page.
- Add UAT coverage that going back from the login page returns to the originating page.
- Do not add mock-based cubit, repository, or service tests.

#### Open questions
- None.

#### Supporting context
Original prompt:
I want a login affordance on the first wizard page in the way you described, it should take the user to the login page, create an empty "under construction" login page and wire it up. Also wire it up to the page that comes after the wizard (signup/sign in option page). Keep in mind you are only creating specs, not changing any code this time around

Codebase grounding:
- The app currently has `SignUpPage` and `EmailConfirmationPage`, but no `LoginPage` implementation.
- `PageName` currently includes `signUp` and `emailConfirmation`, but no `login` route.
- The post-wizard account option page is `LandingPage`.
- `LandingPage` currently has a login-labeled secondary action whose tap handler is empty.
- A shared prompt-link UI pattern already exists as `LaLinkPromptMolecule`.
