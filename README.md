# TelegramStickers

The application have to help in creating stickers from Photo Library or Photo Camera.

The architecture of application is MVP. 
There are 4 screens: 
  - The "MainModule" is start screen. It is responsible for choosing the preferred way to load the image 
    and contains the "CanvasLayer" responsible for selecting the desired part of the image with a finger.
  - The "SelectedPhotosModule" was created for PHAuthorizationStatus.limited. It shows the selected photos.
  - The "ResultOfChangesModule" shows a final sticker and saves it. BUG: It saves png with background
  - The "InfoModule" displays a table of contacts, where there is a link to the developer, support chats. Need to replace links.


https://user-images.githubusercontent.com/92917245/178698513-0848665c-5288-48d3-8341-f1fcdf5e336e.MP4
