# Project 7 - *TaskMate*

Submitted by: **Andry Rakotonjanabelo**

**TaskMate** is an iOS app that allows users to manage daily tasks through a clean task list and calendar-based UI. It helps users stay organized by adding, completing, editing, and viewing tasks, all with persistence between sessions.

Time spent: **3** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] App displays a list of tasks  
- [x] Users can add tasks to the list  
- [x] Session persists when application is closed and relaunched (tasks don’t get deleted when closing app)  
  - [x] Note: You have to quit the app, not minimize it, in order to see the persistence.  
- [x] Tasks can be deleted  
- [x] Users have a calendar view via navigation controller that displays tasks  

The following **additional** features are implemented:

- [x] Tasks can be toggled completed  
- [x] User can edit tasks by tapping on the task in the feed view  

## Video Walkthrough

![Walkthrough Video](Andry-task-demo.gif)

## Notes

Some challenges I encountered included:
- Implementing persistence with `UserDefaults` in a way that supports updating existing tasks without duplicating them.
- Managing UI updates when tasks were marked as complete and ensuring the button states reflected the task model properly.
- Understanding and setting up the Tab Bar Controller correctly, especially when connecting existing navigation controllers and preserving the flow of each section.

Overall, this project helped reinforce my understanding of iOS MVC, view lifecycle, and data persistence.

## License

    Copyright 2025 Andry Rakotonjanabelo

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
