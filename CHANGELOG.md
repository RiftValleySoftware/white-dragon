**1.0.14.2000** *December 29, 2020*
- Fixed a bug, when fetching users by login ID.

**1.0.12.2000** *December 14, 2020*
- Fixed a bug, when fetching "things."

**1.0.11.2000** *December 9, 2020*
- Adds support for a fast check of visible users by name and ID.

**1.0.10.2000** *December 5, 2020*
- Adds a "force dirty" for password changes.

**1.0.9.0000** *November 24, 2020*
- Fixes an issue, where the tokens were not being saved properly for login edits.

**1.0.8.0000** *November 18, 2020*
- This requires BAOBAB 1.0.3 or greater.
- A number of various fixes:
    - The "original vs. changed" data is now set when it is SENT to the server, as opposed to after receiving confirmation (It is reset after receiving the response anyway).
    - There's some basic refactoring, to arrange things better.
    - The API for the user creation allows a separate login, but defaults to both at once.
    - The God Admin now automatically has all privileges.
    - New items are now automatically "dirty."
    - Added a parameter to the user creation API that allows specification that it is a manager.
    - We can now request all editable users.
    - We can now convert logins between standard users, and managers. This has a risk: If a user has tokens that we (as a manager) can't see, then those tokens will be deleted by the transition.
    - It is now possible to test a set of tokens, and get a simple, opaque count of how many logins have access to each (this includes logins we can't see).
    
**1.0.4.0000** *October 7, 2020*
- Fixed an issue, where thing responses were not being sent back to the app from White Dragon.

**1.0.3.0000** *September 26, 2020*
- Changed all the old-fashioned type(of: self) to Self.
- Made one of the captured contexts use a weak (as opposed to unowned) self

**1.0.2.0000** *September 25, 2020*

- Fixed a documentation issue.
- Fixed a problem where new values were not being saved.
- Fixed a deprecated property issue.
- Fixed a misnamed method issue.

**1.0.1.0000** *September 15, 2020*

- Tweaked for the newest Xcode.

**1.0.0.0000** *September 5, 2020*

- Beta.

**1.0.0.1000** *November 3, 2018*

- Alpha. This is feature-complete, but is in dire need of unit tests.
