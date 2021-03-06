require 'test_helper'

class QualitiesControllerTest < ActionController::TestCase
  setup do
    @quality = qualities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:qualities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quality" do
    assert_difference('Quality.count') do
      post :create, params: { quality: { name: @quality.name, order: @quality.order }}
    end

    assert_redirected_to quality_path(assigns(:quality))
  end

  test "should show quality" do
    get :show, params: { id: @quality }
    assert_response :success
  end

  test "should get edit" do
    get :show, params: { id: @quality }
    assert_response :success
  end

  test "should update quality" do
    patch :update, params: {id: @quality, quality: { name: @quality.name, order: @quality.order }}
    assert_redirected_to quality_path(assigns(:quality))
  end

  test "should destroy quality" do
    assert_difference('Quality.count', -1) do
      delete :destroy, params: { id: @quality }
    end

    assert_redirected_to qualities_path
  end
end
