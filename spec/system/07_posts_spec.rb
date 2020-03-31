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

  scenario "ポストページでポスト未入力のユーザーが、「ポストする」ボタンをクリックしたとき、ポスト投稿は失敗しポスト未入力のエラーメッセージを確認できること" do
    user = create_user(1)
    content = ""
    error_message = "ポストを入力してください"
    post_count = Post.count
    sign_in(user)
  
    visit posts_path
    fill_in :post_content, with: content
    click_on :post_button

    expect(current_path).to eq posts_path
    expect(page).to have_text error_message
    expect(Post.count).to eq post_count
  end

  scenario "ポストページでポストを141文字以上入力したユーザーが、「ポストする」ボタンをクリックしたとき、ポスト投稿は失敗しポスト文字数超過のエラーメッセージを確認できること" do
    # テスト用のユーザーを作成する
    user = create_user(1)
    # このテストシナリオで使うポスト内容として141文字を定義する    
    content = "a" * 141
    # このテストシナリオで期待するエラーメッセージを定義する
    error_message = "ポストは140文字以内で入力してください"
    # テスト開始前のDB内のPostの数を記憶しておく
    post_count = Post.count
    # userでサインインする
    sign_in(user)
 
    # ポストページにアクセスする
    visit posts_path
    # ポスト入力欄にcontentを入力する
    fill_in :post_content, with: content
    # 投稿するボタン（#post_button）をクリックする
    click_on :post_button

    # 現在のページがポストページであることを検証する
    expect(current_path).to eq posts_path
    # ページ内に期待するエラーメッセージが表示されていることを検証する
    expect(page).to have_text error_message
    # ポスト入力欄に入力していたポスト内容がそのまま残っていることを検証する
    expect(find("#post_content").value).to eq content
    # DB内のPostの数が変わらない（=Postの登録が失敗している）ことを検証する
    expect(Post.count).to eq post_count
  end  

  scenario "ポストページでポストを正しく入力したユーザーが、「ポストする」ボタンをクリックしたとき、ポスト投稿が成功しポスト入力フィールドがクリアされ、ポスト一覧の最上部に投稿したポストを確認できること" do
    # テスト用のユーザーを作成する
    user = create_user(1)
    # このテストシナリオで使うポスト内容を4つ用意する
    # "Hello, world.":  通常のポスト内容
    # "a":              0文字がNGなので境界値として1文字のポスト内容を用意
    # "a" * 140:        141文字がNGなので境界値として140文字のポスト内容を用意
    # "Hello.\nWorld.": 特殊なケースとして改行が入っているポスト内容を用意
    contents = ["Hello, world.", "a", "a" * 140, "Hello.\nWorld."]
    # userでサインインする
    sign_in(user)

    # contentsの中から1つずつをテストする
    contents.each do |content|
      # テスト開始前のDB内のPostの数を記憶しておく
      post_count = Post.count
     
      # ポストページにアクセスする
      visit posts_path
      # ポスト入力欄にcontentを入力する
      fill_in :post_content, with: content
      # 投稿するボタン（#post_button）をクリックする
      click_on :post_button

      # 現在のページがポストページであることを検証する
      expect(current_path).to eq posts_path
      # ポスト内容がクリアされていることを検証する
      expect(find("#post_content").value).to eq ""
      # DB内のPostが1つ増えている（=投稿したポストが保存された）ことを検証する
      expect(Post.count).to eq post_count + 1
      # ポストページのポスト一覧の一番上に投稿したポストが表示されていることを検証する
      expect(find("#posts_list").all(".post-item").first).to have_text content
      expect(find("#posts_list").all(".post-item").first).to have_text user.name
    end
  end  

  scenario "サインイン済のユーザーは、ポストページで全ユーザーのポストを投稿日時降順で閲覧できること" do
    # テスト用のユーザーを作成する
    user1 = create_user(1)
    user2 = create_user(2)
    # ポストを用意する
    posts = []
    posts.unshift Post.create(content: "first post", user: user1)
    posts.unshift Post.create(content: "初めてのポスト", user: user2)
    posts.unshift Post.create(content: "second post!!", user: user1)
    # userでサインインする
    sign_in(user1)

    # ポストページにアクセスする
    visit posts_path

    # 投稿日時降順でポストが表示されていることを検証する
    posts.each_with_index do |post, i|
      expect(find("#posts_list").all(".post-item")[i]).to have_text post.user.name
      expect(find("#posts_list").all(".post-item")[i]).to have_text post.content
    end
  end  

  scenario "サインイン済のユーザーが、ポストページでポストのユーザー名をクリックしたとき、そのユーザーのユーザー詳細ページに遷移すること" do
    # テスト用のユーザーを作成する
    user1 = create_user(1)
    user2 = create_user(2)
    # ポストを用意する
    posts = []
    posts.unshift Post.create(content: "First Post!!", user: user1)
    posts.unshift Post.create(content: "初めてのポスト", user: user2)
    # user1でサインインする
    sign_in(user1)

    posts.each_with_index do |post, i|
      # ポストページにアクセスする
      visit posts_path
      # 上からi番目のポストのユーザー名をクリックする
      find("#posts_list").all(".post-item")[i].find(".post-user-name").click

      # 現在のページがクリックしたポストのユーザーのユーザー詳細ページであることを検証する
      expect(current_path).to eq user_path(post.user)
    end
  end
end