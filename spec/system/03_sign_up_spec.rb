feature "ユーザーとして、サインアップしたい", type: :system do
  background do
    @user = User.new(name: "John Smith", email: "john@sample.com", password: "john1234")
  end

  scenario "未サインインのユーザーが、トップページで「Sign up now!」ボタンを選択したとき、サインアップページに遷移すること" do
    visit root_path
    click_on :sign_up_link
    expect(current_path).to eq sign_up_path
  end

  scenario "サインアップページで「お名前」を入力できること" do
    visit sign_up_path
    fill_in :user_name, with: @user.name
    expect(find("#user_name").value).to eq @user.name
  end

  scenario "サインアップページで「メールアドレス」を入力できること" do
    visit sign_up_path
    fill_in :user_email, with: @user.email
    expect(find("#user_email").value).to eq @user.email
  end

  scenario "サインアップページで「パスワード」を入力できること" do
    visit sign_up_path
    fill_in :user_password, with: @user.password
    expect(find("#user_password").value).to eq @user.password
  end

  scenario "サインアップページで「パスワード」はマスク化されること" do
    visit sign_up_path
    fill_in :user_password, with: @user.password
    expect(find("#user_password")[:type]).to eq "password"
  end

  scenario "サインアップページで「パスワード」を入力したユーザーが、「パスワードを表示する」チェックボックスにチェックをいれたとき、「パスワード」が表示されること" do
    visit sign_up_path
    fill_in :user_password, with: @user.password
    check :visible_password
    expect(find("#user_password")[:type]).to eq "text"
  end

  scenario "サインアップページで「パスワード」を入力したユーザーが、「パスワードを表示する」チェックボックスのチェックを外したとき、「パスワード」がマスク化されること" do
    visit sign_up_path
    fill_in :user_password, with: @user.password
    check :visible_password
    uncheck :visible_password
    expect(find("#user_password")[:type]).to eq "password"
  end

  scenario "サインアップページで「お名前」を入力していないユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「お名前」未入力のエラーメッセージが表示されること" do
    error_message = "お名前を入力してください"

    visit sign_up_path
    fill_in :user_name, with: ""
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message
  end

  scenario "サインアップページで「お名前」を51文字以上入力したユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「お名前」文字数超過のエラーメッセージが表示されること" do
    error_message = "お名前は50文字以内で入力してください"

    visit sign_up_path
    fill_in :user_name, with: "a" * 51
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message

    fill_in :user_name, with: "a" * 50
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).not_to eq sign_up_path
    expect(page).not_to have_text error_message
    expect(current_path).to eq user_path(User.find_by(email: @user.email))
  end

  scenario "サインアップページで「メールアドレス」を入力していないユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「メールアドレス」未入力のエラーメッセージが表示されること" do
    error_message = "メールアドレスを入力してください"

    visit sign_up_path
    fill_in :user_name, with: @user.name
    fill_in :user_email, with: ""
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message
  end

  scenario "サインアップページで「メールアドレス」を256文字以上入力したユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「メールアドレス」文字数超過のエラーメッセージが表示されること" do
    error_message = "メールアドレスは255文字以内で入力してください"

    visit sign_up_path
    fill_in :user_name, with: @user.name
    fill_in :user_email, with: "a" * 245 + "@sample.com"
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message

    fill_in :user_email, with: "a" * 244 + "@sample.com"
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).not_to eq sign_up_path
    expect(page).not_to have_text error_message
    expect(current_path).to eq user_path(User.find_by(email: "a" * 244 + "@sample.com")) 
  end

  scenario "サインアップページで「メールアドレス」を誤ったフォーマットで入力したユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「メールアドレス」フォーマットチェックエラーのエラーメッセージが表示されること" do
    error_message = "メールアドレスは不正な値です"

    visit sign_up_path
    fill_in :user_name, with: @user.name
    fill_in :user_email, with: "sample.com"
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message
  end

  scenario "サインアップページで「メールアドレス」がすでに登録済みのメールアドレスを入力したユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「メールアドレス」重複のエラーメッセージが表示されること" do
    error_message = "メールアドレスはすでに存在します"
    @user.save

    visit sign_up_path
    fill_in :user_name, with: @user.name
    fill_in :user_email, with: @user.email.upcase
    fill_in :user_password, with: @user.password
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message
  end

  scenario "サインアップページで「パスワード」を入力していないユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「パスワード」文字数不足のエラーメッセージが表示されること" do
    error_message = "パスワードは6文字以上で入力してください"

    visit sign_up_path
    fill_in :user_name, with: @user.name
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: ""
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message
  end

  scenario "サインアップページで「パスワード」を5文字以下で入力したユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは失敗し「パスワード」文字数不足のエラーメッセージが表示されること" do
    error_message = "パスワードは6文字以上で入力してください"

    visit sign_up_path
    fill_in :user_name, with: @user.name
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: "john1"
    click_on :sign_up_button

    expect(current_path).to eq sign_up_path
    expect(page).to have_text error_message

    fill_in :user_password, with: "john12"
    click_on :sign_up_button

    expect(current_path).not_to eq sign_up_path
    expect(page).not_to have_text error_message
    expect(current_path).to eq user_path(User.find_by(email: @user.email))
  end

  feature nil, type: :system do
    background do
      @welcome_message = "サインアップありがとう"

      visit sign_up_path
      fill_in :user_name, with: @user.name
      fill_in :user_email, with: @user.email
      fill_in :user_password, with: @user.password
      click_on :sign_up_button
    end

    scenario "サインアップページで「お名前」「メールアドレス」「パスワード」を正しく入力したユーザーが、「Sign up!」ボタンをクリックしたとき、サインアップは成功し、そのユーザーのユーザー詳細ページにサインイン済状態で遷移すること" do
      expect(current_path).to eq user_path(User.find_by(email: @user.email))
      expect(page).not_to have_selector "#header_sign_in_link"
      expect(page).to have_selector "#header_sign_out_link"
    end

    scenario "サインアップに成功したユーザーは、遷移後のユーザー詳細ページで自分の入力した「お名前」を確認できること" do
      expect(page).to have_text @user.name
    end

    scenario "サインアップに成功したユーザーは、遷移後のユーザー詳細ページで自分の入力した「メールアドレス」を確認できること" do
      expect(page).to have_text @user.email
    end

    scenario "サインアップに成功したユーザーは、遷移後のユーザー詳細ページでウェルカムメッセージを確認できること" do
      expect(page).to have_text @welcome_message
    end

    scenario "サインアップに成功したユーザーは、遷移後のユーザー詳細ページをリロードしたとき、ウェルカムメッセージを確認できなくなること" do
      visit current_path
      expect(page).not_to have_text @welcome_message
    end
  end

  scenario "サインアップページで「登録済みの方はこちら」リンクを選択したとき、サインインページに遷移すること" do
    visit sign_up_path
    click_on :sign_in_link
    expect(current_path).to eq sign_in_path
  end
end