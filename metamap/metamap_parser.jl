using DataFrames
using MySQL
using CSV


function remove_brackets(str::String)
    str = replace(str, "[" => "")
    str = replace(str, "]" => "")
    return str
end


function get_position(incorrect_position::String)
    position = incorrect_position
    if length(position) != 0
        if length(split(position, r"[,;]")) > 1
            position = split(position, r"[,;]")[1]
        end
        if occursin("/", position)
            split_position = split(position, "/")
            start = parse(Int, split_position[1])
            offset = parse(Int, split_position[2])
            endd = start + offset - 1
        else
            start = position
            endd = 0
        end
    else
        start = missing
        endd = missing
    end
    return start, endd
end


function get_true_text(str::String)
    str = split(str, r"[-]")[4]
    str = replace(str, "[" => "")
    str = replace(str, "/" => " ")
    str = replace(str, "\"" => "")
    return str
end     


# ~~~~ SET NOTE TYPE ~~~~
NOTE_TYPE = "SHORT_TEXT"

# get TUI to 4-letter code mappings from umls_sn table in pursacit server
username = ENV["PURSA_USER"]
password = ENV["PURSA_PASSWORD"]
con_tui = MySQL.connect("pursamydbcit.services.brown.edu", username, password; db="umls_sn")

tui_map = MySQL.query(con_tui, "select UI, ABR from SRDEF", DataFrame)
from = [:UI, :ABR]
to = [:TUI, :tui_abbr]
rename!(tui_map, [f => t for (f,t) = zip(from, to)])

fname = "/data/git/stronghold_examples/metamap/data/output/single_input_file.txt.out"
columns = [:note_id, :output_type, :score, :preferred_name, :CUI, 
           :tui_abbr, :positional, :section, :start_end, :miscellaneous]
st = CSV.read(fname; delim='|', datarow=1, header=columns)

# clean up 4-letter code and join
st[:tui_abbr] = map(remove_brackets, st[:tui_abbr])
st = join(st, tui_map, on=:tui_abbr)

# remove brackets from start_end position
st[:start_end] = map(remove_brackets, st[:start_end])

# parse positional information
correct_positions = map(get_position, st[:start_end])
p_start = []
p_end = []
for p in correct_positions
    push!(p_start, p[1])
    push!(p_end, p[2])
end

# get true text
true_text = map(get_true_text, st[:positional])

df = st[[:note_id, :CUI, :preferred_name, :TUI, :score, :section]]
df[:negation] = missing
df[:textsem] = missing
df[:refsem] = missing
df[:scheme] = missing
df[:pos_start] = p_start
df[:pos_end] = p_end
df[:note_category] = NOTE_TYPE
df[:true_text] = true_text

# write parsed metamap output to CSV
CSV.write("/data/git/stronghold_examples/metamap/data/output/parsed_single_input_file.csv", df)


