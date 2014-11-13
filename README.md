Chess
=====

This in-Terminal Chess game is playable using a custom (if hacky) GUI. Give it a try by using AWDS to move the cursor and the spacebar to select and drop pieces.

###Notable Features

####Terminal GUI

A special Cursor class determines which place on the chess board is 'active.' The master Game class instatiates a cursor and shifts the 'active' square based on keyboard input. Values are modded so that players have quickly move the cursor across the board. 
