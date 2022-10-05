export type DataSourceAddRequest = {
    id: number
    dbType: number
    desc: string
    host: string
    dbName: string,
    password: string
    port: number
    url: string
    username: string
}



export interface UserState {
    id: number;
    token: string;
    avatar: string | undefined;
    name: string;
    phone: string;
    role: number;
}



export type ProjectAddRequest = {
    id: number;
    name: string
    projectName: string
}
