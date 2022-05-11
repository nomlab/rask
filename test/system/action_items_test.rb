require "application_system_test_case"

class ActionItemsTest < ApplicationSystemTestCase
  setup do
    @action_item = action_items(:one)
  end

  test "visiting the index" do
    visit action_items_url
    assert_selector "h1", text: "Action Items"
  end

  test "creating a Action item" do
    visit action_items_url
    click_on "New Action Item"

    fill_in "Summary", with: @action_item.summary
    fill_in "Uid", with: @action_item.uid
    fill_in "Url", with: @action_item.url
    click_on "Create Action item"

    assert_text "Action item was successfully created"
    click_on "Back"
  end

  test "updating a Action item" do
    visit action_items_url
    click_on "Edit", match: :first

    fill_in "Summary", with: @action_item.summary
    fill_in "Uid", with: @action_item.uid
    fill_in "Url", with: @action_item.url
    click_on "Update Action item"

    assert_text "Action item was successfully updated"
    click_on "Back"
  end

  test "destroying a Action item" do
    visit action_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Action item was successfully destroyed"
  end
end
