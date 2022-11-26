import os

liste1 = map(lambda x : '"'+x+'"',os.listdir("."))
liste2 = map(lambda x : x.replace(".svg",""),os.listdir("."))
print(",".join(liste1) + "\n" + ",".join(liste2))
