# Sharecart

## Table of Contents
1. [Overview](#Overview)
2. [Technically Amibguous Challenges](#Technically-Ambiguous-Challenges)
3. [Product Spec](#Product-Spec)
4. [Parse Cloud Code](#Parse-Cloud-Code)

## Overview
### Description
The app allows users to create a living grocery list and share it with a group of people (e.g. office, home).

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** Notifications sent when changes occur to lists and to notify list members that a user is shopping, etc.
- **Story:** The app can help users purchase the items they need no more or less than they need. It makes it easy for people who share a space to communicate what they need or not with their group members.
- **Market:** Potential user base is large as a lot of people share living spaces and this app can easily make their experience of grocery shopping better. Countless social groups can benefit from this app.
- **Habit:** People use shopping lists often and Sharecart is a better way to do them!
- **Scope:** The app main functionality (a shared list system) can be implemented within the program period while leaving extra time for additional features such as notifications.

## Technically Ambiguous Challenges

* Shared read/write access to grocery list
    * Permissions to read\write will depend on whether a user is part of a list. Implementing this is not as straightforward as setting a user role (e.g. administrator) as the read\write permissions apply to specific lists\items. Further, users could edit the same item simultaneously and have conflicting changes that need to be addressed.
* Live notifications of changes to the grocery list
    * Up to date information of the list and its items is an essential feature of the app. Any changes to the list by other users need to be communicated in real time. The app will not implement push notifications which requires considering other ways to relay updates to users in a clear manner.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [X] Secure indirect access to database through Parse cloud code 
- [x] User can register
- [x] User can login
- [x] Login persistence
- [x] Logout function
- [x] User can create a grocery list
- [x] User can see list of lists he joined\created
- [x] User can see list of items in a list
- [x] User can add items to a grocery list
    - [ ] Use an API to look up items
- [ ] User can share a grocery list with other users
    - [ ] list number and passcode
- [ ] User can mark items as purchased
- [ ] User can see general information about the list
    - [ ] short summary in main screen
- [ ] User can leave a list
- [ ] Changes by other users are sent to the user as they occur

**Optional Nice-to-have Stories**

- [ ] User can indicate that they started\stopped shopping
    - [ ] the list view should show who's currently shopping
- [ ] Automatically stop shopping after X minutes
- [ ] Notification when changes occur
    - [ ] shopping status to all members
    - [ ] items edited, added, removed, etc. to members currently shopping (give option for users to choose whether they want notifications even if not shopping)
- [ ] Priority specification with corresponding colors in cell
    - [ ] high priority item edit notifications are sent to all users forcibly
- [ ] Lists can be shared with a link
- [ ] Items are ordered based on priority and date of last update
    - [ ] uncompleted\unpurchased items will be prioritized
- [ ] Indicator for who requested\wants an item
    - [ ] show in item cell
- [ ] Swipe left\right to show options such as edit\complete
- [ ] User can add pictures to item
- [ ] User can add notes to an item 
- [ ] Tap to view details
    - [ ] expand cell to show more information
    - [ ] unexpanded cell should show minimum amount of information
- [ ] Chat room for each list
- [ ] Send pictures in chat
- [ ] Recipe\pre-set system to add items at once
    - [ ] Use recipe from an API
    - [ ] Create custom recipes
- [ ] Custom tab bar in list to switch from\to items view to\from chat as well as add pop up
- [ ] Customize notification settings per list
- [ ] Come up with an easier way to invite users
- [ ] Tap outside create new list controller to cancel
- [ ] Add ProgressHUD to indicate activity

### 2. Screen Archetypes

* Login\Register Screen
* Main Screen
   * Shows a table view of the lists where a user is currently a member. Swipe gestures on cells show edit\leave buttons. There would be a navigation bar item to create\join lists.
* Create\Join List Screen
    * Pop up screen that allows users to enter ID and passcode of a list to join or enter a name for a new list.
* List Screen
   * Current items in the list are shown at the top of a table view with the older items at the bottom with fewer details (can click to expand).
   * Item details has 3 states (requester is whoever indicates they want the item)
       * Default: shows name, picture of item, quantity, update date, few requester profile images\names, note up to a character limit.
       * Expanded: entire note, all requesters information, and additional picture, if any, are shown.
       * Minimized: name, picture, and date.
   * "Currently shopping" view with button to toggle status 
* Add\Edit Item Screen
* List Information Screen
    * Information about the list is shown including current members.
    * Settings = if any
* Chat screen
    * Individual chat room for each list

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* Login\Register (Required) -> Main Screen
* Main Screen -> Create\Join Screen
    * Navigation bar item
* Main Screen -> List Screen
    * Table View Cell Selection
* List Screen -> Add\Edit Item
    * New items created after clicking a navigation bar item (or custom tab bar to not cluster too many buttons in navigation bar)
    * Existing items edited after clicking the edit button shown by swipe gesture
* List Screen -> List Information Screen
* List Screen -> Chat Screen

## Parse Cloud Code
The backend of the app is powered by Parse's cloud code which is stored in the server side. 

![Sharecart](https://user-images.githubusercontent.com/63553192/179326718-2bb02287-a96b-4d4a-93b6-8552aedb2237.png)


### Permissions
Although Parse has built-in permission checks, they are not enough to ensure the app is working as intended. For example, for a list member to add another user to a list, they would need write permissions to list row in the database. This allows them to easily tamper the data. Most worrying, however, the list can break if changes were to be made before syncing with the server. For example, a new member of a list could be removed because the local version of the list is not updated to include that new member yet. To prevent incorrect or unauthorized access to the database, the cloud code can serve as a gate keeper.

### Change Logging
Cloud code is also useful in logging updates or changes concering a user, e.g. a list's name has been changed. These updates can then be be saved in a separate table and loaded when the app launches. As the apps runs, a websocket that is facilitated through Parse Live Query receives updates right after they occur. It does depend on a query that requires Parse permissions but is still secure as it only needs read permissions and goes through Parse's own authentication checks.
