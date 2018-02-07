## Activity Board

[![Build Status](https://secure.travis-ci.org/codetriage/codetriage.svg?branch=master)](http://travis-ci.org/codetriage/codetriage)

## We think your activity should be rewarded.

We believe that developers can contribute to their communities via open source projects. We want to encourage developers to contribute and think they should also get rewarded.


## How Does it Work?

You sign up to follow a repository, once a day you'll be emailed with an open issue from that repository, and instructions on how to triage the issue in a helpful way. In the background we use Sidekiq to grab issues from GitHub's API, we then use another background task to assign users who subscribe to a repository one issue each day.


## Run CodeTriage

### Dependencies

Make sure you have bundler, then install the dependencies:

```shell
$ gem install bundler
$ bundle install
```

### Database
* Create a database (default is PostgreSQL)
* Copy database.yml and if you need, setup your own database credentials
* Run migrations

```shell
$ cp config/database.example.yml config/database.yml
$ bin/rake db:create
$ bin/rake db:schema:load
```

### Install Redis

CodeTriage requires Redis for background processing.

**Homebrew**

If you're on OS X, Homebrew is the simplest way to install Redis:

```shell
$ brew install redis phantomjs memcached
$ redis-server
```

You now have Redis running on 6379.

**Other**

See the Download page on Redis.io for steps to install on other systems: [http://redis.io/download](http://redis.io/download)

### Environment

If you want your users to sign up with Github, register a [GitHub a new OAuth Application](https://github.com/settings/applications/new). The urls you are asked to provide will be something like this:

- URL: `http://localhost:3000`
- Callback URL: `http://localhost:3000/users/auth/github/callback`

Then add the credentials to your .env file:

```shell
$ echo GITHUB_APP_ID=foo >> .env
$ echo GITHUB_APP_SECRET=bar >> .env
$ echo PORT=3000 >> .env
```

### Running the app

Start your app using [Heroku Local](https://devcenter.heroku.com/articles/heroku-local)

```shell
$ heroku local -f Procfile.development
12:00:03 AM web.1    |  [70676] - Worker 0 (pid: 70696) booted, phase: 0
12:00:04 AM worker.1 |  INFO: Booting Sidekiq with redis options {:url=>nil}
```

CodeTriage should now be running at [http://localhost:3000](http://localhost:3000)


## Tests

```shell
$ bin/rake db:create RAILS_ENV=test
$ bin/rake db:schema:load RAILS_ENV=test
```

You may need a github API token to run tests locally. You can get this by spinning your local server, clicking the "sign in" button and going through the OAuth flow.

Note you may need to create your own app on GitHub for CodeTriage
[here](https://github.com/settings/developers), and replace the values
previously set (via the above) for `GITHUB_APP_ID` and `GITHUB_APP_SECRET` in
order to complete the OAuth flow locally.

Once you've done this spin down your server and run this:

```
$ bin/rails c
> `echo GITHUB_API_KEY=#{User.last.token} >> .env`
```

Make sure it shows up in your `.env`:

```
> puts File.read(".env")
```

Now you should be able to run tests

```
$ bin/rake test
```

## Writing tests

If you need to mock out some github requests please use VCR. Put anything that may create an external request inside of a vcr block:

```
VCR.use_cassette('my_vcr_cassette_name_here') do
  # ... code goes here
end
```

Make sure to name your cassette something unique. The first time you run tests you'll need to set a [record mode](https://relishapp.com/vcr/vcr/v/2-8-0/docs/record-modes). This will make a real-life request to github using your `GITHUB_API_KEY` you specified in the `.env` and record the result. The next time you run your tests it should use your "cassette" instead of actually hitting github. All secrets including your `GITHUB_API_KEY` are filtered out, so you can safely commit the resultant. When running on travis the VCR cassettes are used to eliminate/minimize actual calls to Github.

The benefit of using VCR over stubbing/mocking methods is that we could swap out implementations if we wanted.

Make sure to remove any record modes from your VCR cassette before committing.


## Modifying Tests

If you need to modify a test locally and the VCR cassette doesn't have the correct information, you can run with [new episodes](https://relishapp.com/vcr/vcr/v/2-8-0/docs/record-modes/new-episodes) enabled.

Make sure to remove any record modes from your VCR cassette before committing.

## Flow

- A user subscribes to a repo
- Consume API: Once a day, find all the repos that haven't been updated in 24 hours, produce issue subscription.
- Issue Assigning [repo]: Find all users subscribed to that repo that haven't been assigned an issue in 24 hours, pick a random issue that the user is not a part of and send them an email.


## Contact

[Brandon Klotz](http://twitter.com/brandonklotz)

Licensed as Open Source! :D
