feature "ユーザーとして、サインアウトしたい", type: :system do
  scenario "サインイン済のユーザーが、ユーザー詳細ページでヘッダーの「Sign out」リンクをクリックしたとき、未サインイン状態になりトップページに遷移すること" do
    user = User.create(name: "John Smith", email: "john@sample.com", password: "john1234")

    visit sign_in_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_on :sign_in_button

    visit user_path(user)

    click_on :header_sign_out_link

    expect(current_path).to eq root_path
    expect(page).to have_selector "#header_sign_in_link"
    expect(page).not_to have_selector "#header_sign_out_link"
  end
end