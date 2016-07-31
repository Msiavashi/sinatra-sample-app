require 'sinatra'
require 'slim'
require 'data_mapper'

# the part below handles the database connections
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
class Task
  include DataMapper::Resource      # this shows that the class is a data_mapper class
  property :id,           Serial
  property :name,         String, :required => true
  property :completed_at, DateTime
end
DataMapper.finalize


# the part below handles the requests
get '/' do
  @tasks = Task.all
  slim :index
end

get '/:task' do
  @task = params[:task]
  slim :task
end

post '/' do
  Task.create :name => params[:task]
  # @task = params[:task]
  # slim :task
  redirect to('/')
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect to('/')
end

put '/task/:id' do
  task = Task.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to('/')
end
