feature "ユーザーとして、ヘッダーリンクからページ遷移できること", type: :system do
  background do
    @user1 = User.create(name: "John Smith", email: "john@sample.com", password: "john1234")
    @user2 = User.create(name: "Taro Tanaka", email: "taro@sample.com", password: "taro1234")
  end

  scenario "未サインインのユーザーが、トップページでヘッダーのロゴをクリックしたとき、トップページに遷移すること" do
    visit root_path
    click_on :header_logo
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、トップページでヘッダーの「Home」リンクをクリックしたとき、トップページに遷移すること" do
    visit root_path
    click_on :header_home_link
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、トップページでヘッダーの「Sign in」リンクをクリックしたとき、サインインページに遷移すること" do
    visit root_path
    click_on :header_sign_in_link
    expect(current_path).to eq sign_in_path
  end

  scenario "未サインインのユーザーは、トップページでヘッダーに「Profile」リンクが存在しないこと" do
    visit root_path
    expect(page).not_to have_selector "#header_profile_link"
  end

  scenario "未サインインのユーザーは、トップページでヘッダーに「Sign out」リンクが存在しないこと" do
    visit root_path
    expect(page).not_to have_selector "#header_sign_out_link"
  end

  scenario "未サインインのユーザーが、サインアップページでヘッダーのロゴをクリックしたとき、トップページに遷移すること" do
    visit sign_up_path
    click_on :header_logo
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、サインアップページでヘッダーの「Home」リンクをクリックしたとき、トップページに遷移すること" do
    visit sign_up_path
    click_on :header_home_link
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、サインアップページでヘッダーの「Sign in」リンクをクリックしたとき、サインインページに遷移すること" do
    visit sign_up_path
    click_on :header_sign_in_link
    expect(current_path).to eq sign_in_path
  end

  scenario "未サインインのユーザーは、サインアップページでヘッダーに「Profile」リンクが存在しないこと" do
    visit sign_up_path
    expect(page).not_to have_selector "#header_profile_link"
  end

  scenario "未サインインのユーザーは、サインアップページでヘッダーに「Sign out」リンクが存在しないこと" do
    visit sign_up_path
    expect(page).not_to have_selector "#header_sign_out_path"
  end

  scenario "未サインインのユーザーが、サインインページでヘッダーのロゴをクリックしたとき、トップページに遷移すること" do
    visit sign_in_path
    click_on :header_logo
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、サインインページでヘッダーの「Home」リンクをクリックしたとき、トップページに遷移すること" do
    visit sign_in_path
    click_on :header_home_link
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、サインインページでヘッダーの「Sign in」リンクをクリックしたとき、サインインページに遷移すること" do
    visit sign_in_path
    click_on :header_sign_in_link
    expect(current_path).to eq sign_in_path
  end

  scenario "未サインインのユーザーは、サインインページでヘッダーに「Profile」リンクが存在しないこと" do
    visit sign_in_path
    expect(page).not_to have_selector "#header_profile_path"
  end

  scenario "未サインインのユーザーは、サインインページでヘッダーに「Sign out」リンクが存在しないこと" do
    visit sign_in_path
    expect(page).not_to have_selector "#header_sign_out_path"
  end

  scenario "未サインインのユーザーが、ユーザー詳細ページでヘッダーのロゴをクリックしたとき、トップページに遷移すること" do
    visit user_path(@user1)
    click_on :header_logo
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、ユーザー詳細ページでヘッダーの「Home」リンクをクリックしたとき、トップページに遷移すること" do
    visit user_path(@user1)
    click_on :header_home_link
    expect(current_path).to eq root_path
  end

  scenario "未サインインのユーザーが、ユーザー詳細ページでヘッダーの「Sign in」リンクをクリックしたとき、サインインページに遷移すること" do
    visit user_path(@user1)
    click_on :header_sign_in_link
    expect(current_path).to eq sign_in_path
  end

  scenario "未サインインのユーザーは、ユーザー詳細ページでヘッダーに「Profile」リンクが存在しないこと" do
    visit user_path(@user1)
    expect(page).not_to have_selector "#header_profile_link"
  end

  scenario "未サインインのユーザーは、ユーザー詳細ページでヘッダーに「Sign out」リンクが存在しないこと" do
    visit user_path(@user1)
    expect(page).not_to have_selector "#header_sign_out_link"
  end

  feature nil, type: :system do

    background do
      visit sign_in_path
      fill_in :user_email, with: @user1.email
      fill_in :user_password, with: @user1.password
      click_on :sign_in_button            
    end

    scenario "サインイン済のユーザーが、ユーザー詳細ページでヘッダーのロゴをクリックしたとき、そのユーザーのユーザー詳細ページに遷移すること" do
      visit user_path(@user2)
      click_on :header_logo
      sleep 1
      expect(current_path).to eq user_path(@user1)
    end

    scenario "サインイン済のユーザーは、ユーザー詳細ページでヘッダーに「Home」リンクが存在しないこと" do
      visit user_path(@user2)
      expect(page).not_to have_selector "#header_home_link"
    end

    scenario "サインイン済のユーザーは、ユーザー詳細ページでヘッダーに「Sign in」リンクが存在しないこと" do
      visit user_path(@user2)
      expect(page).not_to have_selector "#header_sign_in_link"
    end

    scenario "サインイン済のユーザーが、ユーザー詳細ページでヘッダーの「Profile」リンクをクリックしたとき、そのユーザーのユーザー詳細ページに遷移すること" do
      visit user_path(@user2)
      click_on :header_profile_link
      expect(current_path).to eq user_path(@user1)
    end

    scenario "サインイン済のユーザーが、ユーザー詳細ページでヘッダーの「Sign out」リンクが存在すること" do
      visit user_path(@user2)
      expect(page).to have_selector "#header_sign_out_link"
    end

  end

end