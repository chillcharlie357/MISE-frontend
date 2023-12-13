import axios from '@ohos/axios'


const instance = axios.create(
  {
    baseURL: 'http://172.31.27.189:4523/m1/3686963-0-default'
  }
)

export default instance;