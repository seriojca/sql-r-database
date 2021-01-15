
temp<-aeroport %>%
  inner_join(locatii)%>%
  group_by(numeregiune)%>%
  summarise(n=n_distinct(numeaeroport))

temp<- avion %>%
  inner_join(zboruri)%>%
  group_by(numeavion)%>%
  summarise(n=n_distinct(idzbor))%>%
  filter (n > c(avion %>%
                  inner_join(zboruri)%>%
                  filter(numeavion=='Airbus A330')%>%
                  summarise(c=n_distinct(idzbor))%>%
                   .$c))

temp<-avion%>%
  distinct(numeavion)%>%
  left_join(avion %>%
              inner_join(zboruri)%>%
              inner_join(rezervari)%>%
              arrange(numeavion, datazbor) %>%                   
              group_by(numeavion) %>%
              mutate (tnumar = row_number()) %>%
              ungroup()%>%
              filter(tnumar==1))%>%
  transmute(numeavion,primulzbor=datazbor)%>%
  left_join(avion %>%
              inner_join(zboruri)%>%
              inner_join(rezervari)%>%
              arrange(numeavion, datazbor) %>%                   
              group_by(numeavion) %>%
              mutate (tnumar = row_number()) %>%
              ungroup()%>%
              filter(tnumar==2))%>%
  transmute(numeavion,primulzbor,zboruldoi=datazbor)%>%
  left_join(avion %>%
              inner_join(zboruri)%>%
              inner_join(rezervari)%>%
              arrange(numeavion, datazbor) %>%                   
              group_by(numeavion) %>%
              mutate (tnumar = row_number()) %>%
              ungroup()%>%
              filter(tnumar==3))%>%
  transmute(numeavion,primulzbor,zboruldoi,zborultrei=datazbor)


temp<- locatii%>%
  unite(numelocatie,c("numelocatie"),sep =" ")%>%
  group_by(numeregiune)%>%
  summarise("Locatii"=toString(numelocatie))%>%
  unite("Regiune",numeregiune)
