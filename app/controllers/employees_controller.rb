# Controller Actions for Employee
class EmployeesController < ApplicationController
  include Pagy::Backend

  before_action :set_employee, only: %i[show edit update destroy]
  before_action :set_new_employee, only: %i[new]
  before_action :create_new_employee, only: %i[create]
  before_action :set_sexes, :set_workspaces, :set_job_roles,
                only: %i[index search new create edit update]

  before_action :set_marital_statuses, :set_cities_and_states,
                :set_contacts, only: %i[new create edit update]

  before_action :set_breadcrumbs

  # GET /employees or /employees.json
  def index
    @pagy, @employees = pagy(Employee.all.order(:full_name), items: 12)
  end

  def search
    filtering_params = params.slice(:id_name, :sex, :workspace_id, :job_role_id)
    @employees = Employee.filter(filtering_params).order(:full_name)
    add_breadcrumb("#{I18n.t('links.filter')} (#{params[:id_name]})")
  end

  # GET /employees/1 or /employees/1.json
  def show
    add_breadcrumb(@employee.full_name, path: employee_path(@employee))
  end

  # GET /employees/new
  def new
    add_breadcrumb(t('new.employee'))
  end

  # GET /employees/1/edit
  def edit
    add_breadcrumb(t('edit.employee'))
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_url(@employee), notice: I18n.t('employee.notice.created') }
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
        format.html { redirect_to employee_url(@employee), notice: I18n.t('employee.notice.updated') }
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
      format.html { redirect_to employees_url, notice: I18n.t('employee.notice.destroyed') }
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

  def create_new_employee
    @employee = Employee.new(employee_params)
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

  def set_cities_and_states
    cep = Cep.instance
    @cities = cep.cities.uniq.map { |city| [city, city] }
    @states = cep.states.map { |state| [state, state] }
  end

  def set_workspaces
    @workspaces = Workspace.all.pluck(:title, :id)
  end

  def set_job_roles
    @job_roles = JobRole.all.pluck(:title, :id)
  end

  def set_contacts
    @contacts = @employee.contacts
  end

  def set_breadcrumbs
    # add_breadcrumb("Admin", admin_home_path) if Current.user.admin?
    add_breadcrumb(I18n.t('activerecord.models.employee.other'), path: employees_path)
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    params.require(:employee).permit(
      :id, :full_name, :date_of_birth, :origin_city, :home_state, :marital_status,
      :sex, :workspace_id, :job_role_id,
      contacts_attributes: %i[id phone mobile_phone email _destroy]
    )
  end
end
