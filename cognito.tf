resource "aws_cognito_user_pool" "jikokanriUserPool" {
  name = "jikokanri_user_pool"
  # ユーザー確認を行う際にEmail or 電話で自動検証を行うための設定
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    # ユーザーに自己サインアップを許可する。
    allow_admin_create_user_only = false
    invite_message_template {
      email_message = " ユーザー名は {username}、仮パスワードは {####} です。"
      email_subject = " 仮パスワード"
      sms_message   = " ユーザー名は {username}、仮パスワードは {####} です。"
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  # 登録するユーザに求める属性
  schema {
    attribute_data_type = "String"
    name = "email"
    required = true
  }
  # ユーザー登録時の招待メッセージの内容。
  verification_message_template {
    # 検証にはトークンではなく、リンクを使用する。
    default_email_option  = "CONFIRM_WITH_LINK"
    email_message         = " 検証コードは {####} です。"
    email_message_by_link = " E メールアドレスを検証するには、次のリンクをクリックしてください。{##Verify Email##} "
    email_subject         = " 検証コード"
    email_subject_by_link = " 検証リンク"
  }
}

resource "aws_cognito_user_pool_client" "jikokanriUserPoolClient" {
  name = "jikokanri_user_pool_client"
  # OAuthを今回しようしないため設定しない。
  # allowed_oauth_flows = ["implicit"]
  allowed_oauth_flows                  = []
  allowed_oauth_flows_user_pool_client = false
  allowed_oauth_scopes                 = []
  callback_urls                        = []

  explicit_auth_flows = [
    # "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    # SRPプロトコルを使用してユーザ名&パスワードを検証する。
    # "ALLOW_USER_SRP_AUTH", 
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    # 更新トークン
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  logout_urls                   = []
  user_pool_id = aws_cognito_user_pool.jikokanriUserPool.id
}

resource "aws_cognito_user_pool_domain" "jikokanriUserPoolDomain" {
  domain       = "jikokanri-user-pool"
  user_pool_id = aws_cognito_user_pool.jikokanriUserPool.id
}