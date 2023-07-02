class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_new_employee, only: %i[ new ]
  before_action :set_marital_statuses, :set_sexes, :set_cities, :set_states,
    :set_job_roles, :set_workspaces, only: %i[ new create edit update ]

  # GET /employees or /employees.json
  def index
    @employees = Employee.all
  end

  def search 
    conditions = { }
    conditions[:id_name] = params[:id_name]
    conditions[:sex] = params[:sex]
    conditions[:workspace_id] = params[:workspace_id]
    conditions[:job_role_id] = params[:job_role_id]
    @employees = Employee.filter_by(conditions)
  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_url(@employee), notice: "Employee was successfully created." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Employee was successfully updated." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end
    
    def set_new_employee
      @employee = Employee.new
    end

    def set_marital_statuses
      @marital_statuses = Employee::MARITAL_STATUSES.map do |marital_status|
        [I18n.t("employee.marital_statuses.#{marital_status}"), marital_status]
      end
    end

    def set_sexes
      @sexes = Employee::SEXES.map do |sex|
        [I18n.t("employee.sexes.#{sex}"), sex]
      end
    end

    def set_cities
      @cities = @employee.cities.map { |city| [city, city] }
    end

    def set_states
      @states = @employee.states.map { |state| [state, state] }
    end

    def set_workspaces
      @workspaces = Workspace.all.pluck(:title, :id)
    end

    def set_job_roles
      @job_roles = JobRole.all.pluck(:title, :id)
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:full_name, :date_of_birth, :origin_city, :home_state, :marital_status, :sex, :workspace_id, :job_role_id)
    end
end

