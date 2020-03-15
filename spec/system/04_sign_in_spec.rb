feature "ユーザーとして、サインインしたい", type: :system do
  background do
    @user = User.create(name: "John Smith", email: "john@sample.com", password: "john1234")
  end

  scenario "サインインページで「メールアドレス」を入力できること" do
    visit sign_in_path
    fill_in :user_email, with: @user.email
    expect(find("#user_email").value).to eq @user.email
  end

  scenario "サインインページで「パスワード」を入力できること" do
    visit sign_in_path
    fill_in :user_password, with: @user.password
    expect(find("#user_password").value).to eq @user.password
  end

  scenario "サインインページで「パスワード」はマスク化されること" do
    visit sign_in_path
    fill_in :user_password, with: @user.password
    expect(find("#user_password")[:type]).to eq "password"
  end

  scenario "サインインページで「パスワード」を入力したユーザーが、「パスワードを表示する」チェックボックスにチェックをいれたとき、「パスワード」が表示されること" do
    visit sign_in_path
    fill_in :user_password, with: @user.password
    check :visible_password
    expect(find("#user_password")[:type]).to eq "text"
  end

  scenario "サインインページで「パスワード」を入力したユーザーが、「パスワードを表示する」チェックボックスのチェックを外したとき、「パスワード」がマスク化されること" do
    visit sign_in_path
    fill_in :user_password, with: @user.password
    check :visible_password
    uncheck :visible_password
    expect(find("#user_password")[:type]).to eq "password"
  end

  scenario "サインインページで「メールアドレス」を入力していないユーザーが、「Sign in」ボタンをクリックしたとき、サインイン失敗のエラーメッセージが表示されること" do
    error_message = "メールアドレスまたはパスワードをもう一度確認してください。"

    visit sign_in_path
    fill_in :user_email, with: ""
    fill_in :user_password, with: @user.password
    click_on :sign_in_button

    expect(current_path).to eq sign_in_path
    expect(page).to have_text error_message
  end

  scenario "サインインページで「メールアドレス」として登録されていないメールアドレスを入力したユーザーが、「Sign in」ボタンをクリックしたとき、サインイン失敗のエラーメッセージが表示されること" do
    error_message = "メールアドレスまたはパスワードをもう一度確認してください。"

    visit sign_in_path
    fill_in :user_email, with: "dummy@sample.com"
    fill_in :user_password, with: @user.password
    click_on :sign_in_button

    expect(current_path).to eq sign_in_path
    expect(page).to have_text error_message
  end

  scenario "サインインページで「メールアドレス」は正しいが「パスワード」を入力していないユーザーが、「Sign in」ボタンをクリックしたとき、サインイン失敗のエラーメッセージが表示されること" do
    error_message = "メールアドレスまたはパスワードをもう一度確認してください。"

    visit sign_in_path
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: ""
    click_on :sign_in_button

    expect(current_path).to eq sign_in_path
    expect(page).to have_text error_message  
  end

  scenario "サインインページで「メールアドレス」は正しいが「パスワード」が正しくないユーザーが、「Sign in」ボタンをクリックしたとき、サインイン失敗のエラーメッセージが表示されること" do
    error_message = "メールアドレスまたはパスワードをもう一度確認してください。"

    visit sign_in_path
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: @user.password + "a"
    click_on :sign_in_button

    expect(current_path).to eq sign_in_path
    expect(page).to have_text error_message      
  end

  feature nil, type: :system do
    background do
      @sign_in_message = "サインインしました。"

      visit sign_in_path
      fill_in :user_email, with: @user.email
      fill_in :user_password, with: @user.password
      click_on :sign_in_button        
    end

    scenario "サインインページで「メールアドレス」「パスワード」に正しい値を入力したユーザーが、「Sign in」ボタンをクリックしたとき、サインイン済状態でそのユーザーのユーザー詳細ページに遷移すること" do
      expect(current_path).to eq user_path(@user)
      expect(page).not_to have_selector "#header_sign_in_link"
      expect(page).to have_selector "#header_sign_out_link"
    end

    scenario "サインインに成功したユーザーは、遷移後のユーザー詳細ページでサインイン成功メッセージを確認できること" do
      expect(page).to have_text @sign_in_message
    end

    scenario "サインインに成功したユーザーは、遷移後のユーザー詳細ページをリロードしたとき、サインイン成功メッセージを確認できなくなること" do
      visit current_path
      expect(page).not_to have_text @sign_in_message
    end
  end

  scenario "サインインページで「登録がまだの方はこちら」リンクを選択したとき、サインアップページに遷移すること" do
    visit sign_in_path
    click_on :sign_up_link

    expect(current_path).to eq sign_up_path
  end
end