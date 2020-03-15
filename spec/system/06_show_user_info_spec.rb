feature "ユーザーとして、他のユーザーの情報を閲覧したい", type: :system do
  background do
    @user1 = User.create(name: "John Smith", email: "john@sample.com", password: "john1234")
    @user2 = User.create(name: "Taro Yamada", email: "taro@sample.com", password: "taro1234")    
  end

  scenario "ユーザーが、存在するユーザーのユーザー詳細ページにアクセスしようとしたとき、そのユーザーの「お名前」「メールアドレス」を確認できること" do

    # Before sign in
    visit user_path(@user1)
    expect(page).to have_text @user1.name
    expect(page).to have_text @user1.email
    expect(page).not_to have_text @user2.name
    expect(page).not_to have_text @user2.email

    visit user_path(@user2)
    expect(page).not_to have_text @user1.name
    expect(page).not_to have_text @user1.email
    expect(page).to have_text @user2.name
    expect(page).to have_text @user2.email

    # After sign in
    visit sign_in_path
    fill_in :user_email, with: @user1.email
    fill_in :user_password, with: @user1.password
    click_on :sign_in_button

    visit user_path(@user1)
    expect(page).to have_text @user1.name
    expect(page).to have_text @user1.email
    expect(page).not_to have_text @user2.name
    expect(page).not_to have_text @user2.email

    visit user_path(@user2)
    expect(page).not_to have_text @user1.name
    expect(page).not_to have_text @user1.email
    expect(page).to have_text @user2.name
    expect(page).to have_text @user2.email
  end

  scenario "ユーザーが、存在しないユーザーのユーザー詳細ページにアクセスしようとしたとき、エラーが発生すること" do
    not_found_message = "The page you were looking for doesn't exist."
    not_found_id = @user2.id + 1
    expect{User.find(not_found_id)}.to raise_exception(ActiveRecord::RecordNotFound)

    # Before sign in
    visit user_path(not_found_id)
    expect(page).to have_text not_found_message

    # After sign in
    visit sign_in_path
    fill_in :user_email, with: @user1.email
    fill_in :user_password, with: @user1.password
    click_on :sign_in_button

    visit user_path(not_found_id)
    expect(page).to have_text not_found_message
  end
end