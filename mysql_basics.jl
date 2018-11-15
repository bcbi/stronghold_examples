using MySQL

"""
    ursa_mysql_connect()
Connect to ursa-mysql. ENV["BROWN_USER"] and ENV["BROWN_USER"] must be defined in
.juliarc.jl file for julia 0.6 or .julia/config/startup.jl for julia > 0.7
"""
function ursa_mysql_connect()
    host = "ursa-mysql"
    username = ENV["BROWN_USER"]
    password = ENV["BROWN_PSSWD"]
    opts = Dict(MySQL.API.MYSQL_ENABLE_CLEARTEXT_PLUGIN => 1, MySQL.API.MYSQL_OPT_RECONNECT => 1)

    conn = MySQL.connect(host, username, password, opts=opts)
    return conn
end

function main()
    conn = ursa_mysql_connect()
    MySQL.disconnect(conn)
end