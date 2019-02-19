# Documentation

This file contains all the information on where each module / component of Picnotes exist.

# User
  * app/controllers/user_controller.rb
    Followers
      View: app/views/users/followers.html.erb
      Controls the followers that are displayed for the current user. The dash variable
      determines whether the user dashboard shows up the personal dashboard or the
      dashboard that shows other people's information.

    Following
      View: app/views/users/following.html.erb
      Controls the people that the current user is following. The dash variable
      determines whether the user dashboard shows up the personal dashboard or the
      dashboard that shows other people's information.

    New
      View: app/views/modals/new_user_modal.html.erb
      Creation of new users on Picnotes.

    Create
      View: Does not have a view, as this is a backend property that saves the created user.
      This function saves the user created from the new view. If a user is saved, this line runs
      [UserMailer.account_activation(@user).deliver_now] which fires off an email to the user that
      their account has been created.

      Mailer: app/mailers/user_mailer.rb
      MailerView: app/view/user_mailer/account_activation.text.erb

    Show
      View: app/views/users/show.html.erb
      This function show all the Picnotes created by a user not the current user.

    Edit
      View: app/views/users/edit.html.erb
      Editing current user.

    Update
      View: Does not have a view, as this is a backend property that saves the edited user.
      This function saves the user edited from the edit view.

# Session
  * app/controllers/sessions_controller.rb
    Index
      View: app/views/feed/index.html.erb
      This is the feed portion, where the user is able to see all the notes from all the
      users that they follow.

    User_Notes
      View: app/views/sessions/user_notes.html.erb
      This shows all the notes that the user has created on their own dashboard.

    New
      View: app/views/sessions/new.html.erb
      Creation of a new session page.

    Create
      View: Does not have a view as this is a backend property that saves the session.
      This function saves the session from the new view page.

    Destroy
      View: Does not have a view as this is a backend property that removes the session.
      This function destroys the session, effectively logging the user off.


# Picnotes
  * app/controllers/notes_controller.rb
    Index
      View: app/views/notes/index.html.erb
      This is where all the notes are shown to the user whether they are logged in or not.
      The search results are where the user is able to change the parameters on the search
      to view different things in the search.

    Show
      View: app/views/notes/note_modal.html.erb
      This is where the notes show up individually. The entire setup is through a modal.

    New
      View: app/views/modals/new_note_modal.html.erb
      This is the modal that pops up when the user is creating a new modal.

    Create
      View: Does not have a view as this is a backend property that saves the note.
      This function saves the note that was created.

    Edit
      View: app/views/modals/edit_note_modal.html.erb
      This is the modal that pops up when the user is editing their note.

    Create
      View: Does not have a view as this is a backend property that saves the note.
      This function saves the note that was edited.

    Destroy
      View: Does not have a view as this is a backend property that deletes the note.
      This function deletes the note.

    Upvote
      View: Does not have a view as this is a backend property that creates a like.
      This function creates a like for the note when it is accessed.

    Downvote
      View: Does not have a view as this is a backend property that creates a dislike.
      This function creates a dislike for the note when it is accessed.

    addfolder
      View: Does not have a view as this is a backend property that pushes note to folder.
      This function is unique and is used to push a note into a specific folder.
