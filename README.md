# whoami which where -h

This is a challenge by SIEDOS delivered on the third stage of my internship onboarding.

Luis Henrique here, but I'm mostly known as Rick or Henrique.

## CONFIG

This is a step-by-step guide on configuring this fork.

### Setting Up RVM

1. Stages for Ubuntu RVM installation:

```bash
sudo apt-get install software-properties-common

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

sudo usermod -a -G rvm $USER

echo 'source "/etc/profile.d/rvm.sh"' >> ~/.bashrc
source ~/.bashrc

# reboot is recommended
# sudo reboot

sudo apt-get install gnupg
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
rvmsudo rvm get master

```

### Installing Ruby Version using RVM

```bash
rvm install 2.4.2 # for this challenge, for example
rvm use 2.4.2
```

1. Setting up folders for every project of such Ruby version:

Run this script to create a folder for every ruby version you have and populate each folder with a .ruby-version file
to always evaluate the ruby version to that of the folder you're changing directory to.

```bash
cd Documents # or any other
mkdir Ruby && cd Ruby
mkdir 2.4.2
touch .ruby-version && echo "2.4.2" > .ruby-version
```

This way every time you cd in this folder or its subfolders, there will be silent `rvm use ${.ruby-version}`

### Add Gitlab SSH

Steps to add SSH key are the following:

```bash
ssh-keygen -t ed25519 -C "your-email"
sudo apt-get install xclip -y
xclip -sel clip < ~/.ssh/id_ed25519.pub # this will send SSH key to your clipboard
```

Now you register your SSH key [here](http://192.168.1.4/profile/keys).
And then you can test if it worked by running:

```bash
ssh -T git@gitlab.com
# if a welcome message is displayed, then your SSH key was added
```

You might also need to config your github light credentials:

```bash
git config --global color.ui true
git config --global user.name "your_name"
git config --global user.email "your_email"
```

### Installing PostgreSQL

To install postgres, let's run the following commands:

```bash
sudo apt-get update
sudo apt install postgresql postgresql-contrib libpq-dev
```

Now let's create a user. Usually you will create a user that matches your Ubuntu username 
(in case you're going for RVM, Ubuntu is pretty much a must).
```bash
sudo -i -u postgres
psql 
# note that you're in db console mode now, use `\quit` to leave if you wish
```

```psql
CREATE ROLE <your_username> LOGIN SUPERUSER;
# 'CREATE ROLE' will display if successful
# Note: if you want to add a password, add `PASSWORD <password>;` after `SUPERUSER`

\du # this should display the account you just created
```

### Forking and Cloning

After forking (cannot be done through command line), we clone:

```bash
cd ~/Documents/ruby/2.4.2
git clone <repo/rh_challenge> # SSH link is what is going to work
cd rh_challenge
```

### Almost Up and Running

Some changes were made to the main repo, these were:

1st change was to delete Gemfile.lock so that the bundler can do its thing.

```bash
cd ~/Documents/ruby/2.4.2/rh_challenge
rm -rf Gemfile.lock # a later command (bundle) will create this file again
```

2nd change is to add `gem 'loofah', '~>2.19.1'` to Gemfile.
Check my Gemfile in case this is hard to grasp.


### Up and Running

```bash
bundle
rails db:create
rails db:migrate
rails s
```

Any errors? Jump to the next section and come back afterwards.

If errors persist, Google is your next best friend.

### WHYYYYYYY

There's a possibility that after running `rails db:create`, the file config/database.yml
is either not found or wrong, in this case, i HIGHLY recommend creating a new rails app
specifying the database with the flag -d, note that the app should have the same name:

*NOTE* that IF you wish to use sqlite3, then you just have to rename /config/database.example.yml
to database.yml. That's how it is in the original repo, but given that there is a `gem 'pg'` in
Gemfile I decided to go on with the original idea. In case you go for this, do not reproduce
the following steps and move back to last section :UpAndRunning.

```bash
cd ~/Documents/ruby/2.4.2/rh_challenge
mkdir temp && cd temp
rails new rh_challenge -d postgresql

# after its done, you can retrieve the database.yml to your original app.

cd rh_challenge/config
mv ../../../config/database.yml ../../../config/database.yml.backup
cp -r database.yml ../../../config/
cd ../../../
rm -rf temp # delete temp app

# finally you can test if this gambiarra worked by 
# running rails `rails db:create` and not getting an error.

cd ../rh_challenge/
rails db:create
```

## PROJECT

Criteria:

- Git Usage
- Clean Code
- Best Practices
- Structure
- Logic
- Delivered Features
- UX
- Guard-Rspec Usage
- SimpleCov Usage


### What

- [ ] A tool that will be used to manage personal data of employees of a public agency. This tool should allow one to register :full_name, :id, :date_of_birth, :origin_city, :home_state, :marital_status, :sex, :workspace, :role.

- [ ] The webapp should have one page that can be used to search one or multiple employees given a :full_name or an :id. There should also be a filter for :home_state, :sex, :workspace and :role. 

- [ ] The former page should list employees in asc order by :full_name, and the items in the listing table are: :full_name, :id, :date_of_birth, :sex, :workspace, :role datum and show, edit, destroy buttons.

- [ ] The Employee model in question should have the following parameters:
    1. :id (must, unique -i)
    1. :full_name (must)
    1. :date_of_birth
    1. :origin_city
    1. :home_state
    1. :marital_status (Solteiro(a), Casado(a), Divorciado(a), Viuvo(a))
    1. :sex (Masculino, Feminino)
    1. :workspace (references Workspace)
    1. :role (references JobRole)

- [ ] Only up to one Employee instance with a certain role can coexist in a giving Workspace instance.

### How

### First Phase

**Creation of models Workspace and JobRoles (already done by default).
No need for a scaffold because no CRUD was required.**

```bash
rails g model Workspace title:string
rails g model JobRole title:string
```

**Creation of scaffold Employee.**

```bash
rails g scaffold Employee full_name:string date_of_birth:date origin_city:string home_state:string marital_status:string sex:string workspace:references job_role:references
```

**Creation of validations in Employee Model.**

First we make sure that Employee belongs_to Workspace and JobRole, and that the former two have has_many :employees.

```ruby
# models/employee.rb
class Employee < ApplicationRecord
  belongs_to :workspace
  belongs_to :job_role
end

# models/workspace.rb
class Workspace < ApplicationRecord
  has_many :employees
end

# models/job_role.rb
class JobRole < ApplicationRecord
  has_many :employees
end
```

Now we can add the validation clauses needed.
 
> I created a custom validation for age not less than 14, but this won't be documented here.

```ruby
# models/employee.rb
class Employee < ApplicationRecord
  // .... //
  validates :marital_status, inclusion: {
    in: ['single', 'married', 'widow'],
    message: :inclusion
  }
  validates :sex, inclusion: {
    in: ['masculine', 'feminine'],
    message: :inclusion
  }
```

I'm all up for I18n feature, so I added to `models.yml` file the errors inside the following cascade: errors.models.employee.attributes.marital_status.inclusion.

And as for options (Masculine, Feminine), I sourced into `models.yml` the options as follows:

```ruby
# config/locales/models.yml
ptBR:
  employee:
    sexes:
      masculine: "Masculino"
      feminine: "Feminino"
en:
  employee:
    sexes:
      masculine: "Masculine"
      feminine: "Feminine"
```

As for Marital Status, the example is the same, so I'll spare you.

Note that inside the Employee Model there should be a helper for calling these options now that we are using I18n.

```ruby
# models/employee.rb
class Employee < ApplicationRecord
  // .... //
  def sex_label
    I18n.t("employee.sexes.#{sex}")
  end
  // .... //
```

Upon the need of using one of the options of the field, instead of using `employee.sex`, go for `employee.sex_label` and it will display the option according to the language chosen.

In the database, I decided to first go for portuguese options but changed my mind along the way because I prefer avoiding special latin characters in the database, nothing especially wrong with it, but I prefer to just avoid it.

**Creation of rule, Workspace having max one Employee with given JobRole.**

We can create a custom validation inside Employee Model.

```ruby
# models/employee.rb
class Employee < ApplicationRecord
  // .... //
  validate :single_job_role_each_worksapce

  private

  def single_job_role_each_worksapce
    if workspace.emplyees.where(job_role_id: job_role_id).exists?
      errors.add(:job_role, [t('single_job'), :workspace].join(" "))
    end
  end

end
```

But this is still a simple custom validation that can easily be done in a more *Rails way*. Therefore we do as follows:

```ruby
# models/employee.rb
class Employee < ApplicationRecord
  // .... //
  validates :job_role_id, uniqueness: { scope: :workspace_id }
  // .... //
end
```

The `uniqueness` validation is pretty straightforward but I learned just about now that it can carry a hash of options, such as scope, which means its uniqueness validation can be set to apply to a certain different Model. This way, the combination of :job_role_id and :workspace_id is unique, permitting only one employee with a specific job role in a workspace. 

To elaborate more on that, we could use a database example. Given a 3 Models: Product, Sell, and Cart. It's important that only one record of Cart is supposed to have the same combination of a sell_id and product_id. In this case, applying now for Rails, we should have the following line in Cart Model: 

```ruby
  validates :sell_id, uniqueness: { scope: :product_id }
```

That was a good analogy, but not more complex, so let's change the combination to :sell_id, :product_id and :client_id. All that needs to be done is to make the parameters of scope an array and populate it with the combination of choice.

```ruby
  validates :client_id, uniqueness: { scope: [:product_id, :sell_id] }
``` 

**Creation of Model Specs using RSpec.**

Let us first make sure that RSpec is installed. 

There should be a `gem 'rpsec-rails'` inside your `Gemfile`. In case there isn't, add it and run `bundle install`. Then, run the following command line:

```bash
rails g rspec:install
```

This will create the spec folder and some of its default files. The spec folder structure is somewhat like this:

```
spec/
  ├── models/
  │   └── employee_spec.rb
  ├── controllers/
  │   └── employees_controller_spec.rb
  ├── features/
  │   └── employee_feature_spec.rb
  └── spec_helper.rb
```

This file structure aforementioned is not laid out yet, we have to create the folders and inside them its files. Let's create one unit test for Employee.

> Note that I introduced to my project the act of testing AFTER creating the Models, but the recommended way of doing it is BEFORE. I have no idea if things have changed, but let that sink in.

```ruby
# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee do
  it "is valid with valid attributes"
  it "is not valid without a full_name"
  it "is not valid with a full_name less than 8 characters"
  it "is not valid with a full_name more than 36 characters"
  it "is not valid with a date_of_birth of someone's who's under 14"
  it "is not valid with a marital status other than employee.marital_statues"
  it "is not valid with a sex other than employee.sexes"
end
```

I declared all the tests (for now) I judge to be necessary but obviously, we have to implement them. As said before, I'll only implement one here:

```ruby
# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee do
  it "is valid with valid attributes" do
    expect(Employee.new).to be_valid
  end
end
```

And now we run the following command line to execute the testing.

```bash
rspec spec/models/employee_spec.rb
```

Oops. That failed. And that's fine, that is part of the **Red, Green, Refactor** philosophy of TDD. For the test to pass now, let's jump in there again and fill the fields before testing with the `expect` method.

```ruby
# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee do
  subject { described_class.new }
  it "is valid with valid attributes" do
    subject.full_name = "This name is 31 characters long"
    subject.date_of_birth = Date.now - 17.year 
    subject.origin_city = "Rio Branco"
    subject.home_state = "AC"
    subject.marital_status = "Single"
    subject.sex = "Masculine"
    subject.workspace_id = Workspace.create(title: "Rapidash").id
    subject.job_role_id = JobRole.create(title: "Ruby Developer").id
    expect(subject).to be_valid
  end
end
```

Now we can see the **Refactor** part of the philosophy and that will help every other test.

```ruby
# spec/models/employee_spec.rb
require 'rails_helper'

RSpec.describe Employee do
  subject {
    described_class.new (
    subject.full_name = "This name is 31 characters long"
    subject.date_of_birth = Date.today - 17.year 
    subject.origin_city = "Rio Branco"
    subject.home_state = "AC"
    subject.marital_status = "single"
    subject.sex = "masculine"
    subject.workspace_id = Workspace.create(title: "Rapidash").id
    subject.job_role_id = JobRole.create(title: "Ruby Developer").id
    )
  }
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
    
  it "is not valid without a full_name" do
    subject.full_name = nil
    expect(subject).to_not be_valid
  end

  # ... #
end
```

After creating the `employee_spec.rb` Model RSpec test. I went along with JobRole,
Workspace, and not-created-yet Contact which will make its way into our application
in the Second Phase, but given the recommendation of creating tests BEFORE the Model,
I'll proceed this way.

A wise or bitter man once said that Model specs (specs is how you usually refer to tests in Rails) are pointless for validations, like checking if a not_null field can be valid being null, and so on. I'm not yet good enough to have a say in this, but what I can do for now is to make this Model Validation Specs shorter and shorter by creating Modules. So I decided to do the following:

Create the following file first.

```ruby
# spec/support/model_helpers.rb
module ModelHelpers
  def not_null(model, attribute)
    subject[attribute] = nil
    expect(subject).to_not be_valid
  end
end
```

Jump into this next file and move to `RSpec.configure do |config|` block and add the include. 

```ruby
# spec/models/employee_spec.rb
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# ... #
# uncomment the next line, it's responsible for finding the support files
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
# ... #
# Add additional requires below this line. Rails is not loaded until this point!
RSpec.configure do |config|
  config.include ModelHelpers
  # ... #
end
```

Given that there are three fields that can't be blank, I'll do an each block inside `spec/models/employee_spec.rb`:

```ruby
# spec/models/employee_spec.rb
# ... #
  %i[ full_name workspace_id job_role_id ].each do |att|
    it "is not valid without #{att}" do
      not_null(subject, att)
    end
  end
# ... #
```

Now with all of this done, we can test `models/employee_spec.rb`. But first, to follow the guidelines of TDD, I'll comment all my validations in Employee Model to see the test fail and go red, and then I'll change it back to what it was to the test go green. I'll spare you the step-by-step on how I'll do this because we've already done it. And yes, I'll validate all my other not_null models validations of other models using the ModelHelpers::not_null method.

Now have a look at my JobRole spec:

```ruby
# spec/models/job_role_spec.rb
require 'rails_helper'

RSpec.describe JobRole do
  subject {
    described_class.new(
      title: "This name is 31 characters long",
    )
  }

  # Best-Case-Scenario
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  # model validation specs
  it "is not valid without title" do
    not_null(subject, title)
  end

  it "validates length of title (3 .. 36)" do
    validate_length(subject, :title, 3, 36)
  end

end
```

Neat, right? Not quite. This code is all the same as Workspace spec file, only difference is that in Workspace, the line is `RSpec.describe Workspace do`. Yes, I'll go for yet another refactor. I swear this is the last.

Let us first create a file inside `/spec/support`.

```ruby
# spec/support/shared_model_specs.rb
module SharedModelSpecs
  RSpec.shared_examples "a valid model" do
    # Best-Case-Scenario
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    # model validation specs
    it "is not valid without title" do
      not_null(subject, :title)
    end

    it "validates length of title (3 .. 36)" do
      validate_length(subject, :title, 3, 36)
    end

    it "validates the uniqueness of title" do
      opt = { :title => "A Random Title" }
      unique(subject, [opt])
    end
  end
end

```

And as expected, we have to add to `RSpec.config` our new 'feature'.

```ruby
# spec/rails_helper.rb
# ... #
RSpec.configure do |config|
  config.include ModelHelpers
  config.include SharedModelSpecs
```

And obviously we use it in our specs:

```ruby
# spec/models/job_role_spec.rb
require 'rails_helper'

RSpec.describe JobRole do
  subject {
    described_class.new(
      title: "This name is 31 characters long",
    )
  }

  include_examples "a valid model"
end

# spec/models/workspace_spec.rb
require 'rails_helper'

RSpec.describe Workspace do
  subject {
    described_class.new(
      title: "This name is 31 characters long",
    )
  }

  include_examples "a valid model"
end
```

And that's it for Model Tests. I have done more than all this, but I've explained myself enough.

**Creation of System Specs using RSpec and Capybara.**

First we have to make some changes. Add `gem 'webdrivers'` to to the `group :test do` block of `Gemfile` and run both `bundle install`.

> Make Sure that you have both Chrome and WebDriver Chrome installed.

Now let us create `spec/system/employee_crud_spec.rb`.

```ruby
require 'rails_helper'

RSpec.describe "Employee CRUD", type: :system do
  describe "index page" do
    it "shows a button to create an Employee" do
      visit employees_path
      expect(page).to have_content(I18n.t('new.employee'))
    end
  end
end
```

Now we'll do a flip. This test I just wrote was an easy one. I'm going to show a hard one now.

> Note that these two lines come after a big number of changes done to both Model,
Controller and Views have been touched to an extent big enough for me not to document. 

As an overview, changes that have been made to tests are: I added a validator method called
`city_should_belong_to_state` in Employee Model, which caused the creation of a YML file
to store all states and its cities, Employee methods to retrieve them from YML, and new
set_ methods to Employee Controller in before_action for new, create, edit, and update
operations, and 3 tests (invalid city, invalid state, city that does not belong to state).

As for views, I have only touched them enough to display the right information.
The *Second Phase* will trigger changes (both frontend and backend) in the forms with the
usage of cocoon (or nested_form), and in the *Third Phase*, visual changes are required,
so there's no need to spend time on this now.

```ruby

```

**Creation of Request Specs using RSpec.**

TODO

**Usage of Guard.**

TODO

**Usage of SimpleCov.**

TODO

**Creation of seeds to populate and test using gem Faker.**

TODO

**Select Tags for State and City done through API.**

TODO

**For styling, we shall use bootstrap.**

Make the following changes and make sure to turn `application.css` into `.scss` if that
is not yet the case.

```ruby
# Gemfile

# frontend
# gem 'bootstrap-sass'
gem 'bootstrap', '~> 5.3.0.alpha3'
```

```scss
# app/assets/stylesheets/application.scss
/*
...
*= require_self
*/

@import "bootstrap";
```

#### Second Phase

**Creation of model Contact with three not null unique fields.**

TODO

**Adjusting of scaffold Employee to has_many Contact.**

TODO

**Creation of more tests.**

TODO

**Usage of Nested_Forms gem for Contact creation. For that, we will also use cocoon.**

Add `
gem 'cocoon', '~> .2'
gem 'foreman', github: 'ddollar/foreman'
` to Gemfile.

Add `//= require cocoon` to application.js.

**Form Validation using field_with_errors and JS to focuson.**

TODO

**I18n.**

```ruby
# app/assets/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    if params[:locale]
      cookies[:locale] = params[:locale]
    end

    if cookies[:locale]
      if I18n.locale != cookies[:locale]
        I18n.locale = cookies[:locale]
      end
    end
  end
end
```

TODO

**Cookies for storing states and cities after first request.**

TODO

### Third Phase

