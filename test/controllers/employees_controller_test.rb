require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
  end

  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_url
    assert_response :success
  end

  test "should create employee" do
    assert_difference('Employee.count') do
      post employees_url, params: { employee: { date_of_birth: @employee.date_of_birth, full_name: @employee.full_name, home_state: @employee.home_state, job_role_id: @employee.job_role_id, marital_status: @employee.marital_status, origin_city: @employee.origin_city, sex: @employee.sex, workspace_id: @employee.workspace_id } }
    end

    assert_redirected_to employee_url(Employee.last)
  end

  test "should show employee" do
    get employee_url(@employee)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_url(@employee)
    assert_response :success
  end

  test "should update employee" do
    patch employee_url(@employee), params: { employee: { date_of_birth: @employee.date_of_birth, full_name: @employee.full_name, home_state: @employee.home_state, job_role_id: @employee.job_role_id, marital_status: @employee.marital_status, origin_city: @employee.origin_city, sex: @employee.sex, workspace_id: @employee.workspace_id } }
    assert_redirected_to employee_url(@employee)
  end

  test "should destroy employee" do
    assert_difference('Employee.count', -1) do
      delete employee_url(@employee)
    end

    assert_redirected_to employees_url
  end
end
