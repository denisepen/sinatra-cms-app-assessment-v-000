require './config/environment'

<<<<<<< HEAD
# if ActiveRecord::Migrator.needs_migration?
#   raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end
=======
if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end
>>>>>>> f808646ded951c76b62fb784e5b4d4f845140743

use Rack::MethodOverride
run ApplicationController
