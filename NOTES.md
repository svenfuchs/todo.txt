Can't figure out if i want the tool to touch the structure or not.

If it does we can do things like sorting done items to the bottom. I guess that
would be fine to leave it to the user, too.

If it does not one can easily separate items, even add comments and stuff. We'd
only work on lines that have the required format.

~~system('todo toggle -f ' . expand('%:p') . ' -- ' . shellescape(getline('.')))~~
