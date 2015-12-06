# TODO.txt [![Build Status](https://secure.travis-ci.org/svenfuchs/todo.txt.png?branch=master)](https://travis-ci.org/svenfuchs/todo.txt)

My personal flavor of the format. [Todo.txt](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format)

## Assumptions

These are my personal opinions, and probably due to how I am used to use my
todo.txt file personally. Your mileage will most probably vary.

* Being able to embed todo.txt item lines into arbirary text files, and format
  a todo.txt file freely (adding section titles, comments, bullet point lists
  etc) is a good thing. A tool must play nice with this and must not rewrite
  any custom formatting.
* An item can belong to one or many projects.
* The concept of "contexts" (phone, work, home) seems like a stale relict from
  the GTD era to me. Does anybody actually use this? Also, the format `@name`
  indicates a person in most contexts nowadays.
* Assigning explicit priorities don't really work well. Re-ordering items on
  the todo.txt list works better.
* A concept of generic key/value pairs seems like a useful addition to make the
  format more flexible and adaptable. These also can be used for, e.g. due and
  done dates (as well as contexts and priorities, if they still seem useful).
* In order to integrate with services and other tools it seems useful to add
  the concept of an `id`. I'll use `[id]` for this. Typing ids is a hassle, so
  the tool should add them automatically.

## Usage

The gem comes with a command line executable, which plays nice with stdin and
command line arguments. It makes most sense when integrated with another UI
such as an editor. I'm using a simple VIM integration.

```
# Input files and stdin

$ cat todo.txt | todo toggle foo   # outputs to stdout
$ todo toggle foo --file todo.txt  # specify the file to work with
$ todo toggle foo                  # should assume ./TODO.txt but i can't figure
                                   # this out, see https://github.com/svenfuchs/todo.txt/blob/master/lib/todo/cli/cmd.rb#L29

# Filtering items

$ todo list --since 2015-12-01 --before 2015-11-01 # by done date
$ todo list --status pending                       # by status
$ todo list --status done                          # by status
$ todo list --project foo                          # by project
$ todo list --project foo --project bar            # by project
$ todo list --text foo                             # by text
$ todo list foo                                    # by text
$ todo list foo --since 2015-12-01 --status done   # by text, done date, and status

# Named dates

$ todo list --since yesterday
$ todo list --since one.week.ago
$ todo list --since 'two weeks ago'
$ todo list --since 1_year_ago
$ todo list --since 'last friday'

# Formats

$ todo list --format short
$ todo list --format full
$ todo list --format id,text,tags

# Toggling

$ todo toggle foo
$ todo toggle --text foo
$ todo toggle -- '- foo' # passing a full item line with a leading `-`

# Archiving

$ todo archive --since 2015-12-01
$ todo archive # defaults to: two weeks ago
```


## Vim integration

* Vim mapping to a todo item status [toggle](https://github.com/svenfuchs/vim-todo.txt/blob/master/ftplugin/todo.vim#L1)
* Vim mapping to done items to idonethis [push](https://github.com/svenfuchs/vim-todo.txt/blob/master/ftplugin/todo.vim#L2)
* Vim mapping to done items to a separate file [archive](https://github.com/svenfuchs/vim-todo.txt/blob/master/ftplugin/todo.vim#L3)

## Mac OSX integration

* to `fswatch` the file, and [git changes to a Gist [launchctl](https://github.com/svenfuchs/todo.txt/blob/master/etc/me.todo-watch.plist) push](https://github.com/svenfuchs/todo.txt/blob/master/bin/push)
