feature "ユーザーとして、ページにダイレクトアクセスしたい", type: :system do

  background do
    @user1 = User.create(name: "John Smith", email: "john@sample.com", password: "john1234")
    @user2 = User.create(name: "Taro Tanaka", email: "taro@sample.com", password: "taro1234")
  end

  scenario "未サインインのユーザーが、トップページにダイレクトアクセスしたとき、トップページが表示されること" do
    visit root_path
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、サインアップページにダイレクトアクセスしたとき、サインアップページが表示されること" do
    visit sign_up_path
    expect(current_path).to eq sign_up_path
  end

  scenario "未サインインのユーザーが、サインインページにダイレクトアクセスしたとき、サインインページが表示されること" do
    visit sign_in_path
    expect(current_path).to eq sign_in_path
  end

  scenario "未サインインのユーザーが、ユーザー詳細ページにダイレクトアクセスしたとき、ユーザー詳細ページが表示されること" do
    visit user_path(@user1)
    expect(current_path).to eq user_path(@user1)

    visit user_path(@user2)
    expect(current_path).to eq user_path(@user2)
  end

  feature nil, type: :system do

    background do
      visit sign_in_path
      fill_in :user_email, with: @user1.email
      fill_in :user_password, with: @user1.password
      click_on :sign_in_button      
    end

    scenario "サインイン済のユーザーが、トップページにダイレクトアクセスしたとき、そのユーザーのユーザー詳細ページが表示されること" do
      visit root_path
      expect(current_path).to eq user_path(@user1)
    end

    scenario "サインイン済のユーザーが、サインアップページにダイレクトアクセスしたとき、そのユーザーのユーザー詳細ページが表示されること" do
      visit sign_up_path
      expect(current_path).to eq user_path(@user1)
    end

    scenario "サインイン済のユーザーが、サインインページにダイレクトアクセスしたとき、そのユーザーのユーザー詳細ページが表示されること" do
      visit sign_in_path
      expect(current_path).to eq user_path(@user1)
    end

    scenario "サインイン済のユーザーが、ユーザー詳細ページにダイレクトアクセスしたとき、ユーザー詳細ページが表示されること" do
      visit user_path(@user1)
      expect(current_path).to eq user_path(@user1)

      visit user_path(@user2)
      expect(current_path).to eq user_path(@user2)
    end

  end

end