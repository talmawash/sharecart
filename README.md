# Sharecart

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The app allows users to create a living grocery list and share it with a group of people (e.g. office, home).

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** Push notifications sent when changes occur to lists, and to notify list members that a user is shopping, etc.
- **Story:** The app can help users purchase the items they need no more or less than they need. It makes it easy for people who share a space to communicate what they need or not with their group members.
- **Market:** Potential user base is large as a lot of people share living spaces and this app can easily make their experience of grocery shopping better. Countless social groups can benefit from this app.
- **Habit:** People use shopping lists often and Sharecart is a better way to do them!
- **Scope:** The app main functionality (a shared list system) can be implemented within the program period while leaving extra time for additional features such as push notifications.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

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


**Optional Nice-to-have Stories**

- [ ] User can indicate that they started\stopped shopping
    - [ ] the list view should show who's currently shopping
- [ ] Automatically stop shopping after X minutes
- [ ] Push notification when changes occur
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

## Wireframes
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
