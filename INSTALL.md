We currently support installing on Debian 5.0 Lenny and Ubuntu 12.04
systems.

Install Ruby’n’Rails
--------------------

CyDoc is developed and tested using Rails 3.2 and Ruby 1.9.

Install packages to needed:

    sudo apt-get install rubygems irb recode sqlite3 libsqlite3-dev libmysqlclient-dev libxml2-dev libxslt-dev cups-bsd cups-client libcups2-dev ruby-dev build-essential
    sudo apt-get install git
    sudo apt-get install sphinxsearch

Then some gems:

    sudo gem install rake bundler

Install fonts for PDF generator
-------------------------------

The font DejaVuSans and DejaVuSans-Bold is used by the PDF generator.

### Debian systems

    sudo apt-get install ttf-dejavu

### Other \*nix systems

Create the folder and place the files there.
The names of these font files should be “DejaVuSans.ttf” and
“DejaVuSans-Bold.ttf”.

    sudo mkdir -p /usr/share/fonts/truetype/ttf-dejavu/

Install CyDoc
-------------

Install current CyDoc from git repostory. We’ll use this checkout as
working directory from now on:

    sudo git clone http://github.com/huerlisi/CyDoc.git
    cd CyDoc

Install dependency gems:

    bundle

Setup database:

Copy database.yml.example to database.yml and edit as needed\
sudo cp config/database.yml.example config/database.yml

    cp config/database.yml.example config/database.yml

Initialize the database:

    bundle exec rake db:setup

Inititalize the sphinx freetext search index:

    bundle exec rake ts:rebuild

An initial tenant and user has been created for you. Please change your
password as soon as possible.

### Run

You should now be able to start CyDoc:

    bundle exec rails server

CyDoc is now available at http://localhost:3000

You can login with username ‘doctor’ and password ‘doctor1234’.

Enjoy!
