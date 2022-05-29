require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

def scrap_page(table,page)
  n = 1
  p = 0

  while n < 2
   
    id_match = "/html/body/section/div/div/div[2]/a[6]"
    shots_on_goal_1 = "/html/body/section/div/div/div[2]/div[1]/div[1]"
    shots_on_goal_2 = "/html/body/section/div/div/div[2]/div[1]/div[4]"
    shots_off_goal_1 = "/html/body/section/div/div/div[2]/div[2]/div[1]"
    shots_off_goal_2 = "/html/body/section/div/div/div[2]/div[2]/div[4]"
    total_shots_1 = "/html/body/section/div/div/div[2]/div[3]/div[1]"
    total_shots_2 = "/html/body/section/div/div/div[2]/div[3]/div[4]"
    blocked_shots_1 = "/html/body/section/div/div/div[2]/div[4]/div[1]"
    blocked_shots_2 = "/html/body/section/div/div/div[2]/div[4]/div[4]"
    goalkeeper_saves_2 = "/html/body/section/div/div/div[2]/div[13]/div[4]"
    goalkeeper_saves_1 = "/html/body/section/div/div/div[2]/div[13]/div[1]"
    possession_1 = "/html/body/section/div/div/div[2]/div[10]/div[1]"
    possession_2 = "/html/body/section/div/div/div[2]/div[10]/div[4]"
    cartons_jaunes_1 = "/html/body/section/div/div/div[2]/div[11]/div[1]"
    cartons_jaunes_2 = "/html/body/section/div/div/div[2]/div[11]/div[4]"
    cartons_rouges_1 = "/html/body/section/div/div/div[2]/div[12]/div[1]"
    cartons_rouges_2 = "/html/body/section/div/div/div[2]/div[12]/div[4]"
    fouls_1 = "/html/body/section/div/div/div[2]/div[7]/div[1]"
    fouls_2 = "/html/body/section/div/div/div[2]/div[7]/div[4]"
    pass_1 = "/html/body/section/div/div/div[2]/div[16]/div[1]"
    pass_2 = "/html/body/section/div/div/div[2]/div[16]/div[4]"




    name_list = [id_match,shots_on_goal_2,shots_off_goal_2,total_shots_2,blocked_shots_2,goalkeeper_saves_1,possession_2,cartons_jaunes_2,cartons_rouges_2,fouls_2,pass_2]


    while p < name_list.length
      if page.xpath(name_list[p]).empty? 
       
        t = "nc"
        while p<11


        table[p] << t
        p = p+1
      end
      else 

      page.xpath(name_list[p]).each do |node|
    
        table[p] << node.text
        end
  end
      p = p + 1
    end
    p = 0
    n = n + 1
  end
  return table
end

# new_csv(table,c)
def new_csv(table)

  columns = table.transpose
  print columns
  l = 0
  report = "Stats_matchs_equipe_exterieur" #report = "journee_#{c}"

  CSV.open("day_csv/#{report}.csv", "w") do |csv|
    # while l < 381
    while l < ((10*38)+1)
      csv << columns[l]
      l = l + 1
    end
  end

end

def perform()
  c = 1230107

  array_id_match = ["MATCH"]
  array_shots_on_goal_1 = ["shots_on_goal - EQUIPE DOM"]
  array_shots_on_goal_2 = ["shots_on_goal - EQUIPE EXT"]
  array_shots_off_1 = ["shots_off - EQUIPE DOM"]
  array_shots_off_2 = ["shots_off - EQUIPE EXT"]
  array_total_shots_1 = ["total_shots - EQUIPE DOM"]
  array_total_shots_2 = ["total_shots - EQUIPE EXT"]
  array_blocked_shots_1 = ["blocked_shots - EQUIPE DOM"]
  array_blocked_shots_2 = ["blocked_shots - EQUIPE EXT"]
  array_goalkeeper_saves_2 = ["goalkeeper_saves - EQUIPE EXT"]
  array_goalkeeper_saves_1 = ["goalkeeper_saves - EQUIPE DOM"]
  array_possession_1 = ["POSSESSION - EQUIPE DOM"]
  array_possession_2 = ["POSSESSION - EQUIPE EXT"]
  array_cartons_jaunes_1 = ["CARTONS JAUNES - EQUIPE DOM"]
  array_cartons_jaunes_2 = ["CARTONS JAUNES - EQUIPE EXT"]
  array_cartons_rouges_1 = ["CARTONS ROUGES - EQUIPE DOM"]
  array_cartons_rouges_2 = ["CARTONS ROUGES - EQUIPE EXT"]
  array_fouls_1 = ["fouls - EQUIPE DOM"]
  array_fouls_2 = ["fouls - EQUIPE EXT"]
  array_pass_1 = ["pass - EQUIPE DOM"]
  array_pass_2 = ["pass - EQUIPE EXT"]
  
  table = [array_id_match,array_shots_on_goal_2,array_shots_off_2,array_total_shots_2,array_blocked_shots_2,array_goalkeeper_saves_1,array_possession_2,array_cartons_jaunes_2,array_cartons_rouges_2, array_fouls_2, array_pass_2]

  while c < 1230487
    url = "https://www.thesportsdb.com/event/#{c.to_s}"
    page = Nokogiri::HTML(URI(url).open())
    # arrays

    results = scrap_page(table,page)
    # new_csv(results,c)

    c = c + 1
  end
  new_csv(results)
end

perform()