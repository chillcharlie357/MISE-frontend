// 约定axios的请求返回response的格式

export type UserProfileResponse = {
  id: number
  avatarUrl: string
  username: string
  phoneNum: string
  description: string
  followers: number
  following: number
}


export type LoginRequest = {
  email: string
  password: string
}

export type LoginResponse = {
  msg: string;
  saTokenInfo: SaTokenInfo;

  [property: string]: any;
}

export interface SaTokenInfo {
  isLogin: boolean;
  loginDevice: string;
  loginId: string;
  loginType: string;
  sessionTimeout: number;
  tag: null;
  tokenActiveTimeout: number;
  tokenName: string;
  tokenSessionTimeout: number;
  tokenTimeout: number;
  tokenValue: string;

  [property: string]: any;
}

