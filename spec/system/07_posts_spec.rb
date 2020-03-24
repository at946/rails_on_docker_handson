# テスト用ユーザーを作成する
def create_user(user_type = 1)
  case user_type
  when 1
    User.create(name: "John Smith", email: "john@sample.com", password: "john1234")
  when 2
    User.create(name: "Taro Tanaka", email: "taro@sample.com", password: "taro1234")
  end
end

# 与えられたユーザーでサインインする
def sign_in(user)
  visit sign_in_path
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_on :sign_in_button
end

feature "ユーザーとして、ポストを投稿したい", type: :system do
  scenario "未サインインのユーザーが、ポストページにアクセスしようとしたとき、トップページにリダイレクトされること" do
    visit posts_path

    expect(current_path).to eq root_path
  end

  scenario "サインイン済のユーザーが、ポストページにアクセスしようとしたとき、ポストページにアクセスできること" do
    user = create_user(1)
    sign_in(user)
     
    visit posts_path

    expect(current_path).to eq posts_path
  end

  scenario "未サインインのユーザーは、トップページでヘッダーにポストページへのリンクを見つけられないこと" do
    visit root_path
    
    expect(page).not_to have_selector "#header_posts_link"
  end

  scenario "未サインインのユーザーは、サインアップページでヘッダーにポストページへのリンクを見つけられないこと" do
    visit sign_up_path
     
    expect(page).not_to have_selector "#header_posts_link"
  end

  scenario "未サインインのユーザーは、サインインページでヘッダーにポストページへのリンクを見つけられないこと" do
    visit sign_in_path

    expect(page).not_to have_selector "#header_posts_link"
  end   
  
  scenario "未サインインのユーザーは、ユーザー詳細ページでヘッダーにポストページへのリンクを見つけられないこと" do
    user = create_user(1)

    visit user_path(user)

    expect(page).not_to have_selector "#header_posts_link"
  end

  scenario "サインイン済のユーザーが、プロフィールページでヘッダーのポストリンクをクリックしたとき、ポストページに遷移すること" do
    user = create_user(1)
    sign_in(user)

    visit user_path(user)
    click_on :header_posts_link

    expect(current_path).to eq posts_path
  end

  scenario "サインイン済のユーザーが、ユーザー詳細ページでヘッダーのポストリンクをクリックしたとき、ポストページに遷移すること" do
    user1 = create_user(1)
    user2 = create_user(2)
    sign_in(user1)

    visit user_path(user2)
    click_on :header_posts_link
    
    expect(current_path).to eq posts_path
  end

  scenario "サインイン済のユーザーが、ポストページでヘッダーのポストリンクをクリックしたとき、ポストページに遷移すること" do
    user = create_user(1)
    sign_in(user)

    visit posts_path
    click_on :header_posts_link

    expect(current_path).to eq posts_path
  end

  scenario "サインイン済のユーザーは、ポストページでポストを入力できること" do
    user = create_user(1)
    content = "Hello world."
    sign_in(user)
 
    visit posts_path
    fill_in :post_content, with: content 
 
    expect(find("#post_content").value).to eq content
  end
  
end