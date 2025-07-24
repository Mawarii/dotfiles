import os, platform

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

if platform.system() == "Windows":
    clear = lambda: os.system('cls')
else:
    clear = lambda: os.system('clear')

print("Verben immer in Grundform\nBsp: ich sagen nichts; der planet heißen mawari\n\n")

words = {"der":"wap","die":"wap","das":"wap","regen":"kunaya","nebel":"tsvina","hallo":"mhoro","tschüss":"mhoro","ja":"ehe","nein":"aihwa","vielleicht":"pamwe","bitte":"waita haku",\
    "danke":"waita hako","entschuldigung":"nidine hurombo","ok":"zvakanaka","verstehen":"ndinonzwisisa","nicht":"kwete","nichts":"hapana","jahre":"goren","her":"pano",\
    "was":"chii", "wo":"kupi","wann":"rini","wer":"ndiani","warum":"sei","name":"zita","alles":"zvese","mawari":"mawari","ehrlichkeit":"kuvimbika","bringen":"uyai","hierher":"pano",\
    "lüge":"kunyep","freunde":"shamwari","nennen":"kudana","heißen":"kudaidzwa","gut":"zvakanaka","vorsicht":"tarisa","gefahr":"nohti","sicherheit":"zvechokwadi",\
    "hilfe":"rubatsiro","fliegen":"ku bhururuka","fahren":"kutyaira","schwimmen":"kushambira","links":"ruboshwe","rechts":"rudyi","hier":"apa","dort":"ipapo","wahrheit":"chokwadi",\
    "zurück":"kumashure","hoch":"yakakwira","runter":"pasi","weit":"kure","fern":"kure","nah":"pedyo","folgen":"migumisiro","bist":"vari","ich":"ini","du":"iwe","er":"iye",\
    "zwischen":"pakati","jetzt":"ikozvino","heute":"nhasi","morgen":"mangwana","gestern":"nezuro","sekunde":"chepiri","minute":"mineti","stunde":"awa","bin":"vari","es":"iye",\
    "tag":"zuva","woche":"vhiki","monat":"mwedzi","jahr":"gore","früh":"kutanga","spät":"kunonoka","uhrzeit":"nguva","wirklich":"zvechokwadi","leuchten":"kuti","sie":"iye",\
    "jahrzehnt":"remagumi","jahrhundert":"remakore","null":"zekri","eins":"poshi","zwei":"piri","drei":"tatu","vier":"mane","fünf":"shanu","sechs":"nanhatu","lügen":"kunyepa",\
    "sieben":"minomwe","acht":"sere","neun":"pfumba","elf":"poshikek","zwölf":"pirikek","dreizehn":"tatukek","vierzehn":"manekek","fünfzehn":"shanukek","seid":"vari",\
    "sechszehn":"nanhatukek","siebzehn":"minomwekek","achtzehn":"serekek","neunzehn":"pfumbakek","zehn":"kekposhi","zwanzig":"kekpiri","dreißig":"kektatu","vierzig":"kekmane",\
    "fünfzig":"kekshanu","sechzig":"keknanhatu","siebzig":"kekminomwe","achtzig":"keksere","neunzig":"kekpfumba","hundert":"hek","tausend":"tek","millionen":"mek","milliarden":"mik",\
    "wir":"vikni","ihr":"vikwe","ding":"chinhu","und":"uye","oder":"kana","weil":"nekuti","kind":"mwana","gruppe":"boka","alter":"zera","mond":"mwed","monde":"mwedzi","sonne":"zuva",\
    "stern":"nyered","sterne":"nyeredzi","welt":"nyika","planet":"pasi","familie":"mhuri","freund":"shamwari","rot":"tsvuku","grün":"girinhi","blau":"buruu","gelb":"yero",\
    "orange":"tsuro","lila":"pepuru","grau":"gireyi","weiß":"chena","schwarz":"zvisik","türkis":"tekoizi","arm":"murombo","hand":"ruoko","bein":"gumbo","fuß":"tsoka","auge":"ziso",\
    "kopf":"musoro","gehirn":"uropi","nase":"mihno","ohr":"nzeve","haar":"bvudzi","augen":"maziso","lippen":"miromo","mund":"muromo","finger":"chigunwe","skelett":"marangwanda",\
    "knochen":"pfupa","haut":"ganda","sein":"kuva","bekommen":"kuwana","geben":"ipa","leben":"hupenyu", "tod":"rufu", "machen":"ita","gehen":"enda","benutzen":"kushandisa",\
    "denken":"funga","kommen":"huya","haben":"kuva","tun":"kuita","sagen":"taura","wissen":"zivo","sehen":"ona","wollen":"kuda","finden":"tsvaga","erzählen":"taura",\
    "fragen":"bvunza","versuchen":"kuedza","schön":"runako","hässlich":"zvakashata","klein":"zvidiki","groß":"hombe","neu":"nyowani","lang":"refu","kurz":"pfupi","weg":"nazura",\
    "großartig":"hukuru","alt":"chembere","jung":"mudiki","anders":"zvakasiyana","wichtig":"zvakakosha","schlecht":"zvakaipa","lustig":"zvinosetsa","ernst":"zvakakomba",\
    "stark":"yakasimba","schwach":"kushsimba","einfach":"nyore","schwer":"zvinorema","traurig":"suwa","glücklich":"kufara","glauben":"tenda","schlau":"chubhu","dumm":"benzi",\
    "können":"unogona","liebe":"rudo","hass":"ruvengo","sehr":"chaizvo","unglaublich":"zvinoshamisa","möglich":"zvinogoneka", "wie":"sei","essen":"idya","zuhause":"kumba",\
    "mögen":"kufari","hunger":"nzara","licht":"chiedza","feuer":"moto","wasser":"mura","trinken":"kunwa","lachen":"seka","nacht":"husiku","abend":"evha","dunkel":"kwasviba",\
    "hell":"kupenya","ein":"on","eine":"one","eines":"ones","einen":"onen","ist":"kuva","idee":"pfungwa","vertrauen":"kuvimba","glück":"mufaro","pech":"munyama","rakete":"muchadenga",\
    "raumschiff":"muchadenga","flugschiff":"ngarava inobhururuka","fremd":"mutorwa","fremde":"mutorwa","fremder":"mutorwa","fremdes":"mutorwa","tot":"akafa","wütend":"hasha",\
    "aggressiv":"hasha","sauer":"hasha","böse":"zvakaipa","nett":"mutsa","freundlich":"hushamwari","gefährlich":"ngozi","sicher":"zvechok","haus":"imba","heimat":"kumusha",\
    "friedlich":"rugare","frieden":"rugare","krieg":"hondo","schlacht":"hondo","sind":"kuva","volk":"vanhu","friedliches":"rugare","friedlicher":"rugare","ort":"nzvimbo",\
    "durst":"nyota","nahrung":"chikafu","käfer":"ngoko","tier":"mhuka","tiere":"mhuka","angst":"kutya","langsam":"zvishoma","schnell":"kutsanya","harmlos":"asingakuvadzi",\
    "wächter":"muchengeti","von":"kubva","vom":"kubva","wieso":"sei","weshalb":"sei","platz":"nzvimbo","gift":"chepfu","giftig":"chepfu","pflanzen":"zvirimwa","früchte":"mihero",\
    "frucht":"mihero","pflanze":"zvirimwa", "wald": "sango", "fluss": "rwizi", "himmel": "denga", "erde": "ivhu", "maschine": "mashini", "computer": "kombiyuta", "energie": "simba", "krieger": "hondo", "heiler": "mushandiri", "händler": "mutengesi", "angst": "kutya", "freude": "mufaro", "wut": "hasha", "trauer": "suwa",
    }
while True:
    try:
        text = input("").strip().lower()
        if text == 'clear' or text == 'c':
            clear()
        elif text == 'quit':
            break
        else:
            inputlist = text.split(' ')
            for word in inputlist:
                print(bcolors.OKGREEN + words[word] + bcolors.ENDC, sep=' ', end=' ', flush=True)
            print('\n')
    except KeyError as wrongWord:
        print(bcolors.FAIL + bcolors.UNDERLINE + '{}' .format(wrongWord) + bcolors.ENDC + bcolors.OKCYAN + " {}".format(text) + bcolors.ENDC + '\n')
        pass
