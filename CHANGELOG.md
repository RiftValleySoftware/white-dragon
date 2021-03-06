**1.1.15.2000** *July 2, 2021*
- Fixed a possible issue with the auto-radius search.

**1.1.14.2000** *June 25, 2021*
- Added some helpful debug statements.

**1.1.13.2000** *June 23, 2021*
- Added access to the API Key and Server Secret (for persistence of login).

**1.1.12.2000** *June 19, 2021*
- Changed all of the unowned selfs to weak, just to be sure. I've had some strange crash reports.

**1.1.11.2000** *June 8, 2021*

- Added a delete() method to the basic entity base class.

**1.1.10.2000** *June 2, 2021*

- Fixed an issue, where a types command was sent, when not logged in.

**1.1.9.2000** *May 31, 2021*

- Fixed a long/lat issue.

**1.1.8.2000** *May 30, 2021*

- Added an initial test, to set the force auth params flag.

**1.1.7.2000** *May 28, 2021*

- Completed consolidation of auth into one method.

**1.1.6.2000** *May 27, 2021*

- Began consolidation of auth into one method.
- Added explicit support for Basic Auth headers, and made the query parameters optional.

**1.1.5.2000** *May 25, 2021*

- Added methods for assigning and removing personal tokens.
- Fixed an issue with not getting un-fuzzed long/lat.

**1.1.4.2000** *May 17, 2021*

- Fixed an issue, where people objects were not being properly returned, in a baseline search.

**1.1.3.2000** *May 16, 2021*

- Updated to latest Xcode and Swift variants.

**1.1.2.2000** *April 22, 2021*

- Removed unused "cruft" code.

**1.1.1.2000** *April 14, 2021*

- The distance is now returned as a [Measurement](https://developer.apple.com/documentation/foundation/measurement) value, and is dynamically created, if possible.

**1.1.0.2000** *March 21, 2021*

- Made the product name "WhiteDragon."
- A number of fixes and improvements, but this is still an interim version.

**1.0.17.2000** *February 2, 2021*
- Addressed an issue, where, under some conditions, it might be possible to get crashes after returning from an NSURLSession.

**1.0.16.2000** *February 2, 2021*
- Fixed an issue, where update URLs were not being properly formed.

**1.0.15.2000** *January 23, 2021*
- Fixed a possible crash, triggered by deallocation in the calling context.

**1.0.14.2000** *December 30, 2020*
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
