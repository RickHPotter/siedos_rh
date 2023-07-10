# whoami which where -h

This is a challenge by SIEDOS delivered on the third stage of my internship onboarding.

Luis Henrique here, but I'm mostly known as Rick or Henrique.

## CONFIG

This is a step-by-step guide on configuring this fork.

---

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

---

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

---

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

---

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

---

### Forking and Cloning

After forking (cannot be done through command line), we clone:

```bash
cd ~/Documents/ruby/2.4.2
git clone <repo/rh_challenge> # SSH link is what is going to work
cd rh_challenge
```

---

### Almost Up and Running

Some changes were made to the main repo, these were:

1st change was to delete Gemfile.lock so that the bundler can do its thing.

```bash
cd ~/Documents/ruby/2.4.2/rh_challenge
rm -rf Gemfile.lock # a later command (bundle) will create this file again
```

2nd change is to add `gem 'loofah', '~>2.19.1'` to Gemfile.
Check my Gemfile in case this is hard to grasp.

---

### Up and Running

```bash
bundle
rails db:create
rails db:migrate
rails s
```

Any errors? Jump to the next section and come back afterwards.

If errors persist, Google is your next best friend.

---

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

---

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


---

### What

- [ ] A tool that will be used to manage personal data of employees of a public agency. This tool should allow one to register :full_name, :id, :date_of_birth, :origin_city, :home_state, :marital_status, :sex, :workspace, :role.

- [ ] The webapp should have one page that can be used to search one or multiple employees given a :full_name or an :id. There should also be a filter for :home_state, :sex, :workspace and :role. 

- [ ] The aforementioned page should list employees in asc order by :full_name, and the items in the listing table are: :full_name, :id, :date_of_birth, :sex, :workspace, :role datum and show, edit, destroy buttons.

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

### FIRST PHASE

---

#### Creation of models Workspace and JobRoles (already done by default).

No need for a scaffold because no CRUD was required.

```bash
rails g model Workspace title:string
rails g model JobRole title:string
```

---

#### Creation of scaffold Employee.

```bash
rails g scaffold Employee full_name:string date_of_birth:date origin_city:string home_state:string marital_status:string sex:string workspace:references job_role:references
```

---

#### For styling, we shall use bootstrap.

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

---

#### I18n.

This is not necessary for the project but I decided to go with it because I liked it.
I'll keep it to minimum. All you need to know is l(Date) formats the date to the default
language chosen, t(text) is the translation for such term in the language chosen, all its
variables are inside the `config/locale/*yml` files. The two remaining config needed are
the following:

```ruby
# Gemfile
gem 'rails-i18n', '~> 5.1'

# initializers/locale.rb 
I18n.available_locales = [:en, :"pt-BR"]
I18n.default_locale = :"pt-BR"

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

---

#### Creation of validations in Employee Model.

First we make sure that Employee belongs_to Workspace and JobRole, and that these two have has_many :employees.

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
  # ... #
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
  # ... #
  def sex_label
    I18n.t("employee.sexes.#{sex}")
  end
  # ... #
```

Upon the need of using one of the options of the field, instead of using `employee.sex`, go for `employee.sex_label` and it will display the option according to the language chosen.

In the database, I decided to first go for portuguese options but changed my mind along the way because I prefer avoiding special latin characters in the database, nothing especially wrong with it, but I prefer to just avoid it.

---

#### Creation of rule, Workspace having max one Employee with given JobRole.

We can create a custom validation inside Employee Model.

```ruby
# models/employee.rb
class Employee < ApplicationRecord
  # ... #
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
  # ... #
  validates :job_role_id, uniqueness: { scope: :workspace_id }
  # ... #
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

---

#### Form Validation using field_with_errors.

This is a good lesson to start understanding Rails Models. Run `rails c` and replicate:

```ruby
# rails c
e = Employee.new
e.full_name = ""
e.errors[:full_name]
# should have validated, right? either save it or ask if its valid
e.valid?
# it returns false and the output of the last command now changes
e.errors[:full_name]
# it returns the validations that didnt pass.
e.errors.full_messages
# this outputs all errors, becasue this is a method.
```

Maybe not so transparent, but `<instance_of_model>.errors` is a Module of
ActiveModel::Errors, and its got attributes that you can access through hash-like
operations `e.errors[:full_name]` and methods like `e.errors.full_messages`.

Note that the elements of errors only get assigned to after you try to save or when
you invoke the `.valid?` method. This method does NOT perform any database operation, 
it only serves as a way of validating the model.

That was on the backend, what about the frontend? When a form is submitted with errors,
what happens is the form gets updated and this module ActiveModel::Errors gets updated
just as well, bringing back in the form, usually at the top, all the validations that
need to be checked before perfming a successful submit. Although putting them at the top
works, I like to lie them right below its fields, and that's why I created the css
snippet below.

```css
// app/assets/stylesheets/application.scss

// ... //

.field_with_errors > input, .field_with_errors + select,
.field_with_errors > select, .field_with_errors > textarea
{ /* .form-control.is-invalid bootstrap */
  border-color: #dc3545;
  padding-right: calc(1.5em + 0.75rem);
}

.invalid-feedback {
  display: none;
  width: 100%;
  margin-top: 0.25rem;
  font-size: .875em;
  color: #dc3545;
}

.field_with_errors + .invalid-feedback, select + .invalid-feedback,
.invalid-feedback + .invalid-feedback
{
  display: block;
}
```

There's more that can be done with JS like validating at real time, but for now, that
is quite enough. Something to note is the use of the class `.field-with-errors` and
`invalid-feedback`. As for the first class, that's a class that is added to the input,
select, label, etc, of the fields that have found to be not valid. Rails does that on
its own and it helps a lot. As for the second class, I created it with bootstrap example
in mind. The thing is to create a div after every form-group with in invalid feedback
and set it do `display: none`, and only show it when it belongs to form-group that has
`field-with-errors` added to its ClassList.

---

#### Creation of Model Specs using RSpec.

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

    # I suppose we should consider blank as null
    subject[attribute] = " " * 8
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
      unique(subject, opt)
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

---

#### Creation of seeds to populate and test using gem Faker.

See `db/seeds.rb` and run it using `rails db:seed`. I could have done a task to run it
with some other stuff, but I think this is enough. With the usage of Faker to make it
all easier, I still had to make some adjustments to prevent errors while creating given
that model validations could ruin it, so watch out for those.

---

#### Select Tags for State and City and validation.

At first I though about using an API to do the job, but I soon changed my thought and
decided to use a yml file to locate all states and cities. This way I can check if
a certain city belongs to a state. Yes, there are occurences where a many cities have
the same name, and that's why I decided to use no IBGE code for the cities, just the
plain name.

First of all, I ported the file to its location: `config/states_and_cities.yml`.
Then I created a constant in my Employee Model. With it, two methods to bring all the
states and all the cities, one method for bringing only the cities that belong to the
chosen state and a validator. My Model is now this way:

```ruby
# app/models/employee.rb
class Employee < ApplicationRecord
  include PascalCase

  # CONSTANTS
  MARITAL_STATUSES = [ 'single', 'married', 'widow' ]
  SEXES = [ 'masculine', 'feminine' ]
  STATES_AND_CITIES = YAML.load_file(Rails.root.join('config', 'states_and_cities.yml'))['estados']

  # VALIDATIONS
  belongs_to :workspace
  belongs_to :job_role
  validate :not_younger_than_14
  validate :city_should_belong_to_state

  # ... #

  def cities
    # TODO: look for cookies first
    STATES_AND_CITIES.flat_map { |state| state['cidades'] }  
  end

  def specific_cities
    states = STATES_AND_CITIES.find do |state|
      state['sigla'] == home_state
    end
    states['cidades'] if states.present?
  end

  def states
    STATES_AND_CITIES.map { |state| state['sigla'] }  
  end

  private

  # ... #

  def city_should_belong_to_state
    return unless origin_city.present? && home_state.present?

    cities_of_state = specific_cities
    if cities_of_state.nil?
      errors.add(:home_state, I18n.t('errors.invalid_state'))
    else
      if cities_of_state.exclude? origin_city
        errors.add(:origin_city, I18n.t('errors.city_not_in_state'))
      end
    end

  end
end
```

This is enough for our Model. Now for our Controller:

```ruby
# app/controllers/employee_controller.rb
class EmployeesController < ApplicationController
  # ... #
  before_action :set_marital_statuses, :set_sexes, :set_cities, :set_states,
    :set_job_roles, :set_workspaces, only: %i[ new create edit update ]
```

This before_action line will set every data that we need when using the select tags. In
a controller like edit (the edit page), we have to see which sex we need to display for
options, and that is available through this before_action. It's not only sex, so that's
why all the other ones are there as well. As pinpoint, I'll explain of this set_methods.

```ruby
# app/controllers/employee_controller.rb
class EmployeesController < ApplicationController
  # ... #
  
  private

  def set_sexes
    @sexes = Employee::SEXES.map do |sex|
      [I18n.t("employee.sexes.#{sex}"), sex]
    end
  end

  def set_cities
    @cities = @employee.cities.map { |city| [city, city] }
  end
```

As for set_sexes, we use a constant that is declared in our Model. As for cities, we
use a method that extracts the cities from a constant in our Model. As for both of them,
when dealing with select_tags, we have to send an array of key:value array. So the first
value is the visual one, and the second value is the id one, the one that is used for db
operations. The output of set_sexes, for example, is (in Portugues i18n):

```ruby
# Employee.new.set_sexes
[ ['Masculino', 'masculine'], ['Feminino', 'feminine'] ]
```

That's how it is done. As for the validation, I created three new specs for cities and
states, either invalid and city_should_belong_to_state. They are pretty much the same as the
others, so I'll spare the details.

---

#### Filter on :sex, :workspace, :job_role on Search Controller.

First of all, let's make some important statements. I'll talk about a `scope` here
in this section, and this scope is a tad different than the one we used in the
validation of a model attribute.

The `scope` used in earlier sections is used, in the context of model validations, to
define additional conditions that are considered when checking the uniqueness of an
attribute, they are always defined within the `validates` method.

```ruby
class Employee < ApplicationRecord
  validates :job_role_id, uniqueness: { scope: :workspace_id }
end
```

The `scope` of this sections is used to define a specific query or set of conditions
that can be applied to retrieve a subset of records from the database. These, in turn,
can accept arguments to customise the query based on the provided parameters.

```ruby
class Employee < ApplicationRecord
  scope :active, -> { where(active: true) }
end

# Usage: Retrieve all active employees
Employee.active
```

I read an article about the search functionality being added directly to the index page
which makes sense, but I decided to separate them. The article also talked about the
bloating of a model or controller. Imagine this scenario: Inside your model, you can
use scopes (which I used) to create pre-selected queries that you'll use on your
controller action of choice. Even if you use many scopes together the final outcome will
be one select with all the conditions, fear not. Well, anyway, about the bloating: what
you might do is to send all the job to the Model (which I did at first, check my code
before this commit), or all the job to the Controller (which makes no sense because I've
learnt that db operations are to be performed in the Model). Any of these options would
make either of the pieces a fat one, instead what the article recommended was to make
them both skinny (small at best, skinny is unrealistic). So I changed my code according
to another article doing the following:

```ruby
# app/models/employee.rb
class Employee < ApplicationRecord
  # ... #
  # SEARCH
  scope :filter_by, -> (conditions) {
    filter_by_id_name(conditions[:id_name])
      .filter_by_sex(conditions[:sex])
      .filter_by_workspace_id(conditions[:workspace_id])
      .filter_by_job_role_id(conditions[:job_role_id])
  }
  scope :filter_by_id_name, -> (id_name) {
    return unless id_name.present?

    id = id_name.to_i
    id = id > 0 ? "id = #{id} or" : "" 
    where("#{id} lower(full_name) LIKE ?", "%#{id_name.downcase}%")
  }
  scope :filter_by_sex, -> (sex) { where sex: sex if sex.present? }
  scope :filter_by_workspace_id, -> (id) { where workspace_id: id if id.present? }
  scope :filter_by_job_role_id, -> (id) { where job_role_id: id if id.present? }
  # ... #

# app/controllers/product_controller.rb
class EmployeesController < ApplicationController
  # ... #
  def search 
    conditions = { }
    conditions[:id_name] = params[:id_name]
    conditions[:sex] = params[:sex]
    conditions[:workspace_id] = params[:workspace_id]
    conditions[:job_role_id] = params[:job_role_id]
    @employees = Employee.filter_by(conditions).order(:full_name)
  end
  # ... #
```

You can see that, in fact, both my Model and my Controller are bloated more than they
should. Given that I created a convention for the scopes `filter_by_<attribute>` then
I can refactor that into a single method instead of using the scope filter_by which
is too big. We'll have a talk about vulnerability of using public_send later.

```ruby
# app/models/employee.rb
class Employee < ApplicationRecord
  # ... #
  # SEARCH
  def filter(filtering_params) # delete filter_by and use this method instead
    results = Employee.where(nil)
    filtering_params.each do |key, value|
      results = results.public_send("filter_by_#{key}", value) if value.present?
    end
    results
  end

# app/controllers/employee_controller.rb
class EmployeesController < ApplicationController
  # ... #
  def search 
    filtering_params = params.slice(:id_name, :sex, :workspace_id, :job_role_id)
    @employees = Employee.filter(filtering_params).order(:full_name)
  end
```

If it worked for you just as it worked for me, we can go for the next refactor which
is to make filter method a Concern so that we can use it in future Models.

```ruby
# app/models/concern/filterable.rb
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end

# app/models/employee.rb
  include PascalCase
  include Filterable
  # ... #
```

Let us talk about two things in Concern and one thing in the filter method. 

As for Concerns, they're quite nice little additions to both our Models and Controllers,
right? Let us understand them a bit deeper. They are, after all, supposed to be Modules
that extend another Module called ActiveSupport::Concern. Inside our custom Concern, we
can create three types of methods. Instance methods, code that will be executed when the
Concern is included in a Model or Controller. For example:

```ruby
module PascalCase
  extend ActiveSupport::Concern

  included do
    before_validation :pascal_case

    def pascal_case
      # do some stuff
    end
  end

end
```

This Concern, when included, will give the Class a new instance method called
pascal_case that will be invoked by an instance of that class. And an addition to this
is the `before_validation` middleware used that means that the pascal_case will execute
right before the instance of such model is validated.

The other way of Concern methods is using a second module called `ClassMethods` inside
our custom module. Another way of achieving the same result is making block called
`class_methods`. Inside of either block all methods will be evaluated from the class
and not the instance of the classes that will include this Concern. For example:

```ruby
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    # do some stuff
  end

  class_methods do
    # do some stuff
  end
end
```

When the method of a Concern is not in either of these blocks, then it will just become
a method to be called from whichever model/controller that included it.

These are my two cents for Concerns. As for our filter method, what is public_send? The
so infamous eval for Ruby. It is very useful for evaluating code with dynamic data. But
attacks like SQL Injections can happen when using public_send and that's why there is
a need to filter what comes in your application. With what we had done in our Controller
(use params[:attribute]) is a good practice but not enough. What we really need to do
is to sanitise our SQL Query, but that already happens under the hood of Rails, and
although we should not care much about it, it is still important to understand. I can
refer this [site](https://guides.rubyonrails.org/security.html#sql-injection) as a good
guide to how SQL Injections work and how Rails deals with them.

---

#### Creation of System Specs using RSpec and Capybara.

Two configurations have to be undergone. One is for FactoryBot and another one is for
Capybara.

Why FactoryBot? FactoryBot provides a convenient way of defining and creating test data
objects, it makes it easy to create instances of your model objects, abstracting away
the complexity of manually setting up test data. It also helps reduce duplication and 
improves test readability. FactoryBot allows you to generate dynamic and randomised
attribute values.

Why Capybara? It is commonly used in combination with RSpec for system testing to
stimulate user interactions with the application and verify expected behaviour. In short, Capybara mimics the user experienceto test functionality the way it will be tested
in real life.

Let us start with our Gemfile. Add `
  gem 'capybara', '~> 2.13'
  gem 'webdrivers'
  gem 'factory_bot_rails'
` to to the `group :test do` block and then run both `bundle install`.

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

This is supposed to work flawlessly, and by the way it's already using Capybara.
Talking about this big rat, let's go through some of its problems with rails html.
There will be a time when you are trying to click on a button but it is a link or vice
versa, and that's why I created a CapybaraHelper Module. Remember to include it in
`spec/rails_helper.rb` config block.

```ruby
# spec/support/capybara_helpers.rb
module CapybaraHelpers
  def click_link_or_button(text)
    if page.has_link?(text, exact: true)
      click_link(text, exact: true)
    elsif page.has_button?(text, exact: true)
      click_button(text, exact: true)
    else
      raise Capybara::ElementNotFound, "Unable to find visible link or button '#{text}'"
    end
  end
end
```

Without more explanations, let's jump to the spec code and see the usage for FactoryBot.

```ruby
# spec/system/employee_crud_spec.rb
require 'rails_helper'

RSpec.describe "Employee CRUD", type: :system do
  describe "index page" do
    before do
      visit employees_path
    end

    it "shows a button to create an Employee" do
      expect(page).to have_content(I18n.t('new.employee'))
    end

    it "takes you to the create_path when the button is clicked" do
      click_link_or_button(I18n.t('new.employee'))
      expect(page).to have_current_path(new_employee_path)
    end

    it "takes you to the show_path when the button Show is clicked"
      click_link_or_button(I18n.t('links.show'))
      expect(page).to have_current_path(show_employee_path(what))
    end

    it "takes you to the edit_path when the button Edit is clicked"
    it "asks you to confirm the deletion when the button Delete is clicked"
    it "asks performs the delete when the delete-confirm is accepted"
    it "asks does not perform the delete when the delete-confirm is denied"

    it "searches using the id_name input search"
    it "searches using the id_name input search and sex"
    it "searches using the id_name input search and sex and w_id"
    it "searches using the id_name input search and sex and w_id and jr_id"
  end

end
```

In the `it "takes you to the show_path when the button Show is clicked"` block,
I end up expecting the current path to be a show_path, but for a show_path to be
consistant, it needs an ID to really SHOW the data of a model instance. So what would
it be the best approach for this? To create an Employee seems like the right choice,
and it is, BUT an Employee is quite lengthy (quite small in terms of real-life apps),
so something that big prone to repetition tends to generate no clean code, and that's
when the FactoryBot shines.

Let us create our first Factory.

```ruby
# spec/factories/employees.rb
FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }
  end
end
```

Yes, you get the drill. We already used Faker before to make seeds, now we'll use it
to make Factories as well, we'll try to make our seeds validations better and use them
in factories as well. And after that, we can freely use them in one-line in any of our
specs which will improve readability and apply to DRY principles.

```ruby
# db/seeds.rb

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

66.times do |index|
  employee = Employee.new(
    full_name: Faker::Name.name.ljust(8, 'x'),
    date_of_birth: Faker::Date.birthday(min_age: 14, max_age: 56),
    marital_status: [ 'married', 'single', 'widow' ].sample,
    sex: [ 'masculine', 'feminine' ].sample
  )
  employee.home_state = employee.states.sample
  employee.origin_city = employee.specific_cities.sample
  employee.workspace = Workspace.all_available.sample
  employee.job_role = (JobRole.all - employee.workspace.employees.map(&:job_role)).sample 

  employee.save!
end

p "Created #{Employee.count} employees."

# app/models/workspace.rb
class Workspace < ApplicationRecord

  scope :all_available, -> {
    joins('LEFT OUTER JOIN employees ON employees.workspace_id = workspaces.id')
      .group('workspaces.id')
      .having('COUNT(employees.id) < ?', JobRole.all.count)
  }
end
```

As you can see I added a scope in Workspace Model for making it easier to retrieve a
Workspace.all with only the ones that have a open vacancy. Now according to what we did
to make `db/seeds.rb` look cleaner, we'll do in our factory.

```ruby
# spec/factories/employees.rb
FactoryBot.define do

  factory :employee do
    full_name { Faker::Name.name }
    date_of_birth { Faker::Date.birthday(min_age: 14, max_age: 56) }
    marital_status { [ 'married', 'single', 'widow' ].sample }
    sex { [ 'masculine', 'feminine' ].sample }

    before(:create) do |employee|
      employee.home_state = employee.states.sample
      employee.origin_city = employee.specific_cities.sample    
      employee.workspace_id = Workspace.all_available.sample.id
      employee.job_role_id = (JobRole.all - employee.workspace.employees.map(&:job_role)).sample.id
    end
  end
end
```

Yes, a bit different with the before(:create) helping us but the idea is pretty much the same. Now let's jump back to our sys spec. This takes
way too long to write, by the way, but here we are. Inside our
`RSpec.describe "Employee CRUD"` block, we already have a `describe "index page"` block, and now we'll go for a `describe "new page"`, so be aware
for the new features.

The `before` block has been utilised before but only for action (of visiting
a new page), now we'll declare variables, and for those to stick, they have to carry the `@` as prefix so they dont't act just like local variables.

Remember about precendece, I NEED a workspace and a JobRole to create an
Employee, so I went along and created a FactoryBot for both of them and we
will be using them here.

The `fill_in` works for input, textarea, and stuff you can 'freely' write
to. The `select` is for select, as the name suggests, watch out for the
syntax.

```ruby
# spec/system/employee_crud_spec.rb
require 'rails_helper'

RSpec.describe "Employee CRUD", type: :system do
  describe "index page" do
    # ... #
  end

  describe "new page" do
    before do
      @workspace = FactoryBot.create(:workspace)
      @job_role = FactoryBot.create(:job_role)
      @employee = FactoryBot.create(:employee)
      visit new_employee_path
    end

    it "does not create a new employee without filled in attributes" do
      count_before = Employee.count
      click_link_or_button I18n.t('new.employee')
      expect(count_before).to eq(Employee.count)
    end

    it "does create a new employee with valid filled in attributes" do
      fill_in 'employee[id]', with: @employee.id
      fill_in "employee[full_name]", with: @employee.full_name
      select @employee.origin_city, from: 'employee[origin_city]'
      select @employee.home_state, from: 'employee[home_state]'
      select @employee.marital_status_label, from: 'employee[marital_status]'
      select @employee.sex_label, from: 'employee[sex]'
      select @employee.workspace.title, from: 'employee[workspace_id]'
      select @employee.job_role.title, from: 'employee[job_role_id]'

      click_link_or_button(I18n.t('new.employee'))

      expect(Employee.last.full_name).to eq(@employee.full_name)
    end
  end
end
```

One thing I noticed is that my sys spec file is getting too big, so I'll separate them
into many files.

Truth is this step caused me to have to revisit a lot of stuff, like views,
I18n, documentation and stuff. So I'll quietly create sys specs for Update and
Delete, and finish the pending tests of the Read spec I started. See ya.

Note: My Sys Specs came out a bit lengthy and -shitty-, so I might document the refactor
and harness in a later time.

---

### SECOND PHASE

---

#### Creation of model Contact with three not null unique fields.

Let's get to it. Run the rails command line.

```bash
rails g model Contact phone:string mobile_phone:string email:string:uniq
```

That's pretty straightforward, right? But there is a mistake, the Contact
belongs to an Employee. We can run `rails d model Contact` and redo the
rails g command with `employee:references` or we can use a migration to
fix that. I'll go for the migration.

```bash
rails g migration AddEmployeeToContact employee:references
```

This will create a new file `db/migrate/**.rb` that will be executed
when you run `rails db:migrate`.

Now that we created our model Contact, let us run the model specs we
created earlier, they might fail, but that's the point and then after
failing we will know how we must architecture our model Contact and its
relations.

```bash
rails db:migrate
rspec spec/models/contact_spec.rb
```

> I created Contact Model Spec and didn't share in the documentation. It is
located at `spec/models/contact_spec.rb`

As expected, the only test that does not fail is the first one because it
validates the best case scenario where no invalid or null attributes are present.

Let us go through the not null tests and the unique :email rule, first we add
the following lines of code to our Model.

```ruby
# app/models/contact.rb
class Contact < ApplicationRecord
  belongs_to :employee

  validates :phone, :mobile_phone, :email, presence: true
  validates :email, uniqueness: true
end

# spec/models/contact_spec.rb
require 'rails_helper'

RSpec.describe Contact do
  # ... #
  # Best-Case-Scenario # ALREADY PASSED
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  # model validation specs
  %i[ phone mobile_phone email ].each do |att|
    it "is not valid without #{att}" do
      not_null(subject, att)
    end
  end

  it "validates uniqueness of email" do
    opt = { :email => "siedos@rhchallenge.com" }
    unique(subject, opt)
  end

  # ... #
end
```

Before running the tests again, having a look at our `contact_spec.rb`, we have
to assume that the second, third and fourth tests have to pass, these are the
not null validation specs. Also the fith test should go green as it is the unique
validation spec. And fair enough, after running the tests, they work.

Now let's check that unique with scope of Employee. That is, an Employee can only
have one Contact with a certain phone, mobile_phone or email. There might another
record of Contact with the same phone (for example) but not for the same Employee,
therefore making it a unique combination of :employee_id and :phone, :employee_id
and :mobile_phone, :employee_id and :email. BUT pay good attention to what is
going to happen. We will, as usual, test it without making changes so that they
go red.

```ruby
# spec/models/contact_spec.rb
# ... #
  %i[ phone mobile_phone ].each do |att|
    it "validates uniqueness of #{att} within the scope of employee_id" do
      opts = { }
      opts[:employee_id] = employee.id
      opts[att] = "62981309721"
      unique(subject, opts)
    end
  end
# ... #

# spec/support/model_helpers.rb 
# ... #
  def unique(subject, fields)
    fields.each do |attribute, value|
      subject[attribute] = value
    end
    subject.save
    expect(subject).to be_valid

    duplicate = subject.dup
    duplicate.save
    # byebug
    expect(duplicate).to_not be_valid
  end
# ... #
```

Remember that no changes have been done to the Contact Model, and yet when yoju
run the tests provided, they will go green. And that is a false-positive and one
of the many reasons you HAVE to see your tests go red first right before making
any changes to the real logic. But how is that possible? uncomment that line 
`byebug` in the unique method and let us run the test again.

```bash
   16:     expect(subject).to be_valid
   17: 
   18:     duplicate = subject.dup
   19:     duplicate.save
   20:     byebug
=> 21:     expect(duplicate).to_not be_valid
   22:   end
   23: 
   24:   def validate_length(subject, attribute, min_length, max_length)
   25:     subject[attribute] = 'x' * (min_length - 1)
(byebug)
```

Something like that will show up at your bash terminal and you can debug your
code. Now, the test only succeeded because the test EXPECTS the result to NOT
be valid. We can see the reasons for that invalidation, but remember we have
TWO instances of Contact in this unique method. The first one is the `subject`,
and the second one is `duplicate`, which as the name suggest, is a duplicate.
Now about the method itself, it changes a subject and changes the fields according
to the `fields` parameter, and then it saves and expects it to be valid, which is,
then this same subject is shallow copied and is attempted to be saved again, which
would violate the unique validation.

Enough talk, in the byebug terminal, write `subject.valid?`, this will likely
return true, run the same command for `duplicate` and it will return false. Now
run `duplicate.errors.full_messages` and there you have it. Your unique :email
validations is giving off false positive errors in other unique field validations.

The truth is, my unique method was faulty, I should have prevented this (and will)
by having another parameter called subject_fields for fields that will only apply
to ONE of both model instances. But regardless of who's at fault, a false positive
happened during the red phase and this helped me greatly in realising a problem
existed in my code. What would happen if I had created the validation and run the
tests? Exactly, the test would go green and I would been mislead to believe
everything was in order when it was not.

Let us fix unique method.

```ruby
# spec/support/model_helpers.rb
# ... #
  def unique(subject, fields, helper)
    fields.each do |attribute, value|
      subject[attribute] = value
      helper[attribute] = value
    end

    subject.save
    expect(subject).to be_valid

    helper.save
    byebug
    expect(helper).to_not be_valid
  end
# ... #
```

Much better. The intention is to use FactoryBot to both create the subject and the
helper instances of the model, they have to both be valid at first, and that is
a good way. After entering the realm of this method, they will both change a given
attribute to the same value, which will be put to test. Subject, the first and
original has to be valid, the second has to not be valid.

I do not use this unique method just for the Contact Model Spec, therefore, fix
it up for the other specs. Inside Contact spec, there is another it test that uses
unique method, fix it as well.

```ruby
# spec/models/contact_spec.rb
# ... #
  it "validates uniqueness of email" do
    opt = { :email => "siedos@rhchallenge.com" }
    unique(subject, opt, helper)
  end
  
  %i[ phone mobile_phone ].each do |att|
    it "validates uniqueness of #{att} within the scope of employee_id" do
      unique(subject, { att => subject[att] }, helper)
    end
  end
# ... #
```

Now the tests fail, as they should. Time to make them green. Let us update our
Model validations.

```ruby
# app/models/contact.rb

  # validates :employee_id, uniqueness: { scope: [:phone, :mobile_phone] }
  validates :phone, :mobile_phone, uniqueness: { scope: :employee_id }
```

Run the tests again and they should succeed.

> Uncomment the first line and comment the other one, and then play with Contact
in rails console, there's a lot to be learnt doing this. By the way, for our needs
the second and third are the ones necessary to do the job well.

Given that I am a novice and you are probably too, then I recommend you to do
the same as me: test this validation in rails console. Create a contact for an
employee, save it, then dup this contact and invoke the `valid?` method for the
validations to rise, and check the errors using `duplicate.errors.full_messages`
and do this step every time you change a field. Change the email first, because
this one is unique regardless of anything. Change each field and run the step,
but don't change the :employee_id, because that's the point of this exercise.
When you have a complete distinct contact with only :employee_id the same as the
original one, you should see that the contact is actually valid.

There are other tests go run and validate, but I believe my documentation so far
is helpful enough.

---

#### Adjusting of scaffold Employee to has_many Contact.

We've seen this before with JobRole and Workspace. I'll just drop the code here.

```ruby
# app/models/employee.rb
class Employee < ApplicationRecord
  # ... #
  has_many :contacts
  # ... #
end
```

---

#### Usage of Cocoon gem for Contact creation.**

Let us set some things first. We will need some gems, cocoon and simpleform, and of course,
jquery which is a dependency of cocoon.

Add `
gem 'haml'
gem 'simple_form'
gem 'cocoon', '~> .2'
` to Gemfile.

Add `
//= require jquery
//= require cocoon
` to application.js.

Before, after or along the way I touched sys specs, model specs and created a contact
factory. I also modified some of the I18n translations. Let this be known.

Cocoon might be a new thing, but before Cocoon, we have to learn simple_form, and I
recommend to use haml with it. Regardless of format used, we have to set up simple_form,
by running `rails generate simple_form:install --botstrap`.

Simple Form, in short, makes things easier to do, the documentation can be helpful but
at least for now, the amount of knowledge we have on rails forms is enough. In this
section I'm not going through code.

But be sure to learn everything in this setup:

```haml
# app/views/employee/_form.html.haml
.row.border.border-2.border-dark
  = simple_form_for @employee, defaults: { wrapper: false } do |f|
    .row.py-3
      .col
        = f.input :id
      .col
        = f.input :date_of_birth, type: 'date', html5: true

    .row.py-3
      .col
        = sf_select f, :sex, @sexes

    .row.py-3
      .col
        = f.association :workspace, collection: @workspaces
      
    .d-flex.justify-content-end
      .py-3
        = link_to t('links.show'), @employee, class: 'btn btn-outline-warning'
      .py-3
        = f.submit action_text, class: 'btn btn-outline-primary'
```

```ruby
# app/helpers/application_helpers.rb
module ApplicationHelper
  # ... #
  def sf_select(form, field, collection, html_class: '')
    options = {
      collection: collection, input_html: { class: "form-select #{html_class}" }
    }
    form.input field, options
  end
end
```

Now that you learnt about the input, association and submit methods for simple_form_for,
we can move for cocoon. 


```haml
# app/views/employee/_form.html.haml
.row.border.border-2.border-dark
  = simple_form_for @employee, defaults: { wrapper: false } do |f|
  # ... #

  
  %h3 Contacts
  #contacts
    .row.py-3.border.border-2.border-dark.mx-auto#contacts-list
      = f.simple_fields_for :contacts do |contact|
      = render 'contact_fields', f: contact
    .links
      = link_to_add_association 'add contact', f, :contacts, class: 'btn btn-outline-success', data: { association_insertion_method: "append", association_insertion_node: "#contacts-list"}


# app/views/employee/_contact_fields.html.haml
.col-4.new-contact
  .nested-fields.py-2.container.m-1
    = f.input :phone, type: 'tel'
    = f.input :mobile_phone, type: 'tel'
    = f.input :email, type: 'email'
    = link_to_remove_association(f, class: 'material-icons d-flex justify-content-end pt-3 text-black text-decoration-none') do
      highlight_off
```

Learn about why there is a need for simple_fields_for to be encapsulated by a div with
id named the plural od your nested model ('#contacts'), why you need .nested-fields
for your contact_fields, link_to_add_association and link_to_remove_association and the
options `data` in link_to_add_association which enable you to insert the new nested-fields
in a certain location with a certain id that you provide, and with association_insertion_method,
you can say if it's added before, after, append or prepend.

And I almost forgot, you need to make some changes to your controllers and models.

```ruby
# app/models/employee.rb
class Employee < ApplicationRecord
  # ... #
  has_many :contacts, inverse_of: :employee
  accepts_nested_attributes_for :contacts, reject_if: :all_blank, allow_destroy: true

# app/models/contact.rb
class Contact < ApplicationRecord
  belongs_to :employee

# app/controllers/employee_controller.rb
class EmployeesController < ApplicationController
  # ... #
  before_action :set_marital_statuses, :set_sexes, :set_cities, :set_states,
    :set_job_roles, :set_workspaces, :set_contacts, only: %i[ new create edit update ]

  # ... #

  private

    def set_contacts
      @contacts = @employee.contacts
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee) .permit(
        :id, :full_name, :date_of_birth, :origin_city, :home_state, :marital_status,
        :sex, :workspace_id, :job_role_id,
        contacts_attributes: [ :id, :phone, :mobile_phone, :email, :_destroy ]
      )
    end
end
```

Some things to add here are:
 
- `inverse_of: :employee` in Employee Model is a cleaner way of
declaring `belongs_to :employee, optional: true` This is so to help RAils know the link
between relations, given that when saving nested items, the parent (employee, ie) is not
yet saved on validation.

- Yes, no changes were necessary in the Contact Model.

- The private method `employee_params` is a lock that gives liberty for a user to share
data based on the field. So for example, for too long I have neglected the fact that
this challenge asks you to make id writable by whoever is registering an employee. Not
too long ago, I decided to stop ignoring that and made it both visible in forms and
a required field, but at first it wasn't updating existing employees or creating new ones
with given id; when creating, it was not even able to save, what was I forgetting? Yes,
I happened to forget about permitting that param by including it in the employee_params.
As for nested-fields like contacts, you declare it as an array with all its fields necessary,
plus the id and an attribute called `_destroy`. When `_destroy` is set, the nested model
will be deleted. In case the nested model was already persisted before, there will be an
id lookup to destroy that instance.

I know this is not ideal documentation, but lately I've been busier with finishing this
challenge than documenting it. Might come back later for better explanations for my
future self.

---

#### Usage of Guard.

Honestly, I guess I made a mistake. Using Guard now after all tests are pretty much
done is useless as is. It's not as bad because there will still be some visual changes
that might provoke remodelling of feature specs, but overall I learnt enough Guard to
know you're supposed to use it as soon as you're writing your first spec. It is easy
as can be: Add the gem, run `bundle`, then configure a bit your guardfile so that it
watches the files and finally run `bundle exec guard` and keep it running. As soon as
you save a file that might change your specs in some way, then the tests which might
have been sabbotaged will execute again with Guard's help.

---

#### Usage of Wicked for Multi-Step Form. 

---

#### Breadcrumb. 

---

### THIRD PHASE

---

#### Usage of SimpleCov.

TODO

---

#### Remodelling of Index Page (Search included).

TODO

---

### DEPLOYE

rails secret
copy output and paste it in production assignment in config/secrets.yml
always watch out for logs/production.log
fix database.yml with a new user and its password

```ruby
# config/database.yml
production:
  <<: *default
  database: rh_challenge_production
  host: localhost
  pool: 5
  username: super
  password: 0619
```

run RAILS_ENV=production bundle exec rake db:create db:schema:load
> to run this seed, you'll have to add faker back into general group in Gemfile.
rake db:migrate db:seed RAILS_ENV=production

rails s -e production

  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.compile = true
  in environment/production.rb

it will work, but without embelishment

assets are missing, my dear friendo

RAILS_ENV=production bundle exec rake assets:precompile


