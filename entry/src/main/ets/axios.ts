import axios from '@ohos/axios'


const instance = axios.create(
  {
    baseURL: 'http://172.17.238.192:4523/m1/3686963-0-default'
  }
)

export default instance;