import axios from '@ohos/axios'


const instance = axios.create(
  {
    baseURL: 'http://172.31.1.179:8080'
  }
)

export default instance;