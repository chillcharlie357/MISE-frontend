// 约定axios的请求返回response的格式
import { expect } from "@ohos/hypium"

export type UserProfileResponse = {
  id: number
  avatarUrl: string
  username: string
  phoneNum: string
  description: string
  followers: number
  following: number
  email:string
}


export type LoginRequest = {
  email: string
  password: string
}

export type EditRequest = {
  avatarUrl: string
  username: string
  description: string
  followers: number
  following: number
  email:string
  id:number

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

export type RegisterRequest = {
  email: string
  password: string
  username: string
}

export type RegisterResponse = {
  msg: string;

  [property: string]: any;
}


export type PostResponse = Array<PostData>;


export type PostData = {
  id: number;
  avatar: string;
  title: string;
  content: string;
  images: Array<string>;
}


export type PostDataGetter = () => Promise<PostResponse> | null;

export type CommentData = {
  id: number;
  avatar: string;
  username: string;
  content: string;
  likes: number;
}

export type CommentResponse = Array<CommentData>


export type CommentDataGetter = () => Promise<CommentResponse> | null;
