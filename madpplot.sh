#!/bin/bash
#Inicializa el parametro para ram
rparam=""
#Directorio madMAx43v3r instalado
cd /home/chi/chia-plotter/build/
#Directorio para memoria ram en caso de utilizarlo verificar permisos de escritura
ramd="/ram/"	
time=300 #tiempo de espera para iniciar nuevo plot
countw=0 #No tocar :)
declare -a tplots=('/media/chi/1/' '/media/chi/2/' '/media/chi/3/' '/media/chi/4/'); #Unidades para plottear ejemplo: ('/dir/1/') o ('/dir/1/' '/dir/2/')
declare -a dds=('/media/chi/d6-1/' '/media/chi/d6-2/') #Unidades para Destino de plots ejemplo: ('/dir/1/') o ('/dir/1/' '/dir/2/')
#Maximo espacio en disco a utilizar
ddmax=80
#Datos de <poolkey> y <farmerkey>
poolc="xch1klvjuh4gm0t9f0305xzznf3a86s2wa4ud89mzru65nh523glq5fsfnxmv8" 
#1----- xch1klvjuh4gm0t9f0305xzznf3a86s2wa4ud89mzru65nh523glq5fsfnxmv8 < ------- Donaciones
fpool=""
#-----------Fin
maxtplot=2 #Maximos plots por unidad, calculados a k32 depende del almacenamiento temporal ~220 GiB. Se recomienda 1 por unidad
maxplot=8 #Numero de plots al mismo tiempo global depende del almacenamiento temporal -1
#Inicio de programa
#Directorio ram temporal con parametro [ram], Ejemplo " ./madt.sh ram " solo si se hace de uno por uno
if [ "$1" == "ram" ]; then
	if [ -d $ramd ]; then
			echo ":>> Directorio ram ya existe"
			sudo mount -t tmpfs -o size=110G tmpfs $ramd
			rparam="-2 $ramd "
		else
			#Crea directorio ram, se solicitaran credenciales
			echo ":>> Intentando crear directorio $ramd"
			mkdir $ramd
			sudo mount -t tmpfs -o size=110G tmpfs $ramd
			rparam="-2 $ramd "
			#echo ":>> Directorio ram creado /mnt/ram/"
	fi
fi	
#Ploteo
while :
do 
	#Check de destinos
	for dst in ${dds[@]} #Recorrido de los directorios de ploteo
	do
			echo ":>> Espacio en disco check: >> $dst"
			ddoc=$(df -hT $dst | awk '{print $6}' |awk -F% '{print $1}')
			#Si es menor al maximo del destino para plots finales inicia el ploteo
			intddoc=${ddoc[0]:4:3}
			echo "	:>> Espacio en disco: >> $dst : $intddoc"
			if [ $((intddoc)) -le $ddmax ]; then 
				echo "	:>> Espacio en disco suficiente: >> $dst"
					#Recorrido de los directorios de ploteo
					for u in ${tplots[@]} 
					do
						taskp=`ps aux | grep -v grep | grep "./chia_plot -n" | wc -l` #Verifica cuantos procesos estan activos maxplot
						if [[ -z $taskp ]] || [[ $taskp -eq 0 ]]; then 
							taskp=1
						fi
						if [ $taskp -le $maxplot ]; then #Crea de uno en uno hasta el maximo maxplot
							echo ":>> En proceso: "$taskp" de; "$maxplot
							tkplot=`ps aux | grep -v grep | grep "./chia_plot -n 1 -r 8 -t $u $rparam" | wc -l` #Verifica si el directorio tplots esta ocupado 
								if [ $tkplot -le $maxtplot ]; then #Si es menor a maxtplot 
									#Ejecuta el comando de madMAx43v3r para plotear
									./chia_plot -n 1 -r 8 -t $u $rparam -d $dst -w -c $poolc -f $fpool & 
									echo "	:>> Completo: "$taskp" Dest; "$u > outmadplot.txt	
								else
									echo "	:>> Destino plots "$u" Ocupado"
								fi
						fi
						sleep $time
					done
				else
				#Sin espacio en destino de los plots
				echo "	:>> Espacio en disco insuficiente: >> $dst << No se puede continuar Espacio actual ocupado $intddoc %"
			fi
	done
        countw=$((countw+1))
    	echo ":>> Enviados a executar: " $countw
done