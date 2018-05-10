#Note: The following code offers two Heatmap Graphs: One offered at Governorate level, other at Community level by Governorate
#Note1:Make sure LastUpdate_Value is a continues value, while Sector and Governorate are as Factor. In Original PVI DB missing values have a "-" wich make R to read it as Character. Review this.

#Install/Load requiered packages
#install.packages("readxl","ggplot2","reshape2")
library(readxl)
library(ggplot2)
library(reshape2)


#Get data soruce
sectors.df.end <- read_excel("C:/Users/julen/Desktop/180501 PVI-DA Specialist/Reports/Palestine/ECHO17FR/DB/PAL PVI Sectors Endline (Qassem).xlsx")
#Restructure data source
sectors.df.end.rest <- melt(sectors.df.end, id=(c("#", "Community","Governorate","Organization","Update")))
#Format data source
names(sectors.df.end.rest)[names(sectors.df.end.rest) == 'variable'] <- 'Sector'
sectors.df.end.rest$value <- sectors.df.end.rest$value * 100
sectors.df.end.rest$Governorate <- factor(sectors.df.end.rest$Governorate)
sectors.df.end.rest$Sector <- factor(sectors.df.end.rest$Sector, levels=c("Access","Access to Services","Civil Society Presence","Demography","Education","Energy","Gender","Health","Land Status","Livelihoods","Protection","Relation w/ PA","Settler Violence","Shelter","Transportation","Wash","Total"))
#Aggregate at Governorate level
attach(sectors.df.end.rest)
sectors.df.end.rest.gov<-aggregate(sectors.df.end.rest, by=list(Governorate,Sector), FUN=mean)
colnames(sectors.df.end.rest.gov)[colnames(sectors.df.end.rest.gov) == 'Sector'] <- 'label1'
colnames(sectors.df.end.rest.gov)[colnames(sectors.df.end.rest.gov) == 'Governorate'] <- 'label2'
colnames(sectors.df.end.rest.gov)[colnames(sectors.df.end.rest.gov) == 'Group.1'] <- 'Governorate'
colnames(sectors.df.end.rest.gov)[colnames(sectors.df.end.rest.gov) == 'Group.2'] <- 'Sector'
colnames(sectors.df.end.rest.gov)[colnames(sectors.df.end.rest.gov) == 'value'] <- 'end.value'
detach(sectors.df.end.rest)


sectors.df.base <- read_excel("C:/Users/julen/Desktop/180501 PVI-DA Specialist/Reports/Palestine/ECHO17FR/DB/PAL PVI Sectors Baseline (Qassem).xlsx")
#Restructure data source
sectors.df.base.rest <- melt(sectors.df.base, id=(c("#", "Community","Governorate","Organization","Update")))
#Format data source
names(sectors.df.base.rest)[names(sectors.df.base.rest) == 'variable'] <- 'Sector'
sectors.df.base.rest$value <- sectors.df.base.rest$value * 100
sectors.df.base.rest$Governorate <- factor(sectors.df.base.rest$Governorate)
sectors.df.base.rest$Sector <- factor(sectors.df.base.rest$Sector, levels=c("Access","Access to Services","Civil Society Presence","Demography","Education","Energy","Gender","Health","Land Status","Livelihoods","Protection","Relation w/ PA","Settler Violence","Shelter","Transportation","Wash","Total"))
#Aggregate at Governorate level
attach(sectors.df.base.rest)
sectors.df.base.rest.gov<-aggregate(sectors.df.base.rest, by=list(Governorate,Sector), FUN=mean)
colnames(sectors.df.base.rest.gov)[colnames(sectors.df.base.rest.gov) == 'Sector'] <- 'label1'
colnames(sectors.df.base.rest.gov)[colnames(sectors.df.base.rest.gov) == 'Governorate'] <- 'label2'
colnames(sectors.df.base.rest.gov)[colnames(sectors.df.base.rest.gov) == 'Group.1'] <- 'Governorate'
colnames(sectors.df.base.rest.gov)[colnames(sectors.df.base.rest.gov) == 'Group.2'] <- 'Sector'
colnames(sectors.df.base.rest.gov)[colnames(sectors.df.base.rest.gov) == 'value'] <- 'base.value'
detach(sectors.df.base.rest)

sectors.df.rest.gov <- cbind(sectors.df.base.rest.gov, sectors.df.end.rest.gov)

sectors.df.rest.gov["caca"] <- " ("
sectors.df.rest.gov["caca1"] <- sectors.df.rest.gov$end.value - sectors.df.rest.gov$base.value
sectors.df.rest.gov["caca2"] <- ")"
sectors.df.rest.gov<- transform(sectors.df.rest.gov,labeed=paste0(round(end.value,0),caca,round(caca1,0),caca2))

View(sectors.df.rest.gov)

#Graph at Governorate level
dev.new()
#Object definition:
ggplot(data=sectors.df.rest.gov, aes(Sector, Governorate)) + #Change the DF name here
  geom_tile(aes(fill = end.value)) +
  geom_text(aes(label = labeed))+
  scale_fill_gradientn(colours=c("white", "lightpink", "lightcoral", "orangered2", "firebrick4"), guide="colorbar") +
  #scale_fill_gradient(low ="white", high ="red")+
  labs(title="Sectors's Vulnerability by Governorate", fill= "PVI Endline Value \n(avg. for Gov.)", x="Sectors",y="Governorates",caption= "More darker red = more vulnerability")+
  #Tittle and format
  #ggtitle(label = "Sectors's Vulnerability by Governorate")+
  theme   (plot.title = element_text(face = 'bold',size = 15),
           panel.background = element_blank(),
           panel.grid.minor = element_line(colour="black"),
           legend.title = element_text(size = 12, face='bold'),
           legend.text = element_text(size = 9),
           legend.position="top",
           legend.background = element_rect(fill="gray95", size=.5, linetype="dotted"),
           legend.key.width = unit(2, "cm"),
           axis.title=element_text(size=12,face="bold"),
           axis.text.x = element_text(angle=-90))