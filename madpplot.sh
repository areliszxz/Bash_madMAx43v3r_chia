#!/bin/bash
rparam=""
#Directorio madMAx43v3r instalado
cd /home/chi/chia-plotter/build/
#Directorio para memoria ram en caso de utilizarlo
ramd="/home/chi/ram/"	
time=300 #tiempo de espera para iniciar nuevo plot
countw=0
tkplot=1
countdown=0 #Contador para salir en caso de fallos
fexit=20 #Numero de chechs fallidos para salir por no tener espacio disponible
declare -a tplots=('/media/chi/1/' '/media/chi/2/' '/media/chi/3/' '/media/chi/4/') #Unidades para plottear ejemplo: ('/dir/1/') o ('/dir/1/' '/dir/2/')
declare -a dds=('/media/chi/D6t-0/') #Unidades para Destino de plots ejemplo: ('/dir/1/') o ('/dir/1/' '/dir/2/')
#Maximo espacio en disco a utilizar
ddmax=95
#Datos de <poolkey> y <farmerkey>
poolc="xch1klvjuh4gm0t9f0305xzznf3a86s2wa4ud89mzru65nh523glq5fsfnxmv8" 
fpool=""
#-----------Fin
maxtplot=1 #Maximos plots por unidad ejemplo 1tb puede crear maximo 32k, 4 plots al mismo tiempo...Se recomienda 1 por unidad
maxplot=1 #Numero de plots al mismo tiempo en todos los directorios temporales
# 1tb M.2 =temp/ 4 ubidades
# Min= maxtplot=1  maxplot= 4 / Max= maxtplot=4 maxplot=1 / Med= maxtplot=2 maxplot=2
#Inicio de programa
#Directorio ram temporal con parametro [ram], Ejemplo ./madt.sh ram solo si se hace de uno por uno
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
			echo "	:>> Espacio en disco: >> $dst : $intddoc %"
			if [ $((intddoc)) -le $ddmax ]; then 
				echo "	:>> Espacio en disco OK: >> $dst : $intddoc %"
					#Recorrido de los directorios de ploteo
					for u in ${tplots[@]} 
					do
						taskp=`ps aux | grep -v grep | grep "./chia_plot -n" | wc -l` #Verifica cuantos procesos estan activos -->>maxplot
						if [[ -z $taskp ]] || [[ $taskp -eq 0 ]]; then 
							taskp=1 
						fi
						if [ $taskp -le $maxplot ]; then #Crea de uno en uno hasta el maximo maxplot
							echo ":>> En proceso: "$taskp" de; "$maxplot
							tkplot=`ps aux | grep -v grep | grep "./chia_plot -n 1 -r 8 -t $u $rparam" | wc -l` #Verifica si el directorio tplots esta ocupado 
							tkplot=$((tkplot+1)) #Inicia en 1 e incrementa +1 para la comparacion
								if [ $tkplot -le $maxtplot ]; then #Si es menor a maxtplot 
									#Ejecuta el comando de madMAx43v3r para plotear
									#read -p "Debug stop"
									./chia_plot -n 1 -r 8 -t $u $rparam -d $dst -w -c $poolc -f $fpool & 
									echo "	:>> Completo: "$taskp" Dest; "$u > outmadplot.txt	
									maxplot=$((maxplot+1))
								else
									echo "	:>> Destino plots "$u" Ocupado"
								fi
						fi
						sleep $time
					done
				else
				#Sin espacio en destino de los plots. Termina programa si supera el maximo de intentos... "variable: fexit"
				echo "	:>> Espacio en disco insuficiente: >> $dst << No se puede continuar Espacio actual ocupado $intddoc %"
				if [ $countdown -ge $fexit ]; then
					read -p "  :>> No se encontraron unidades con espacio para almacenar plots Destino"
					df -h
					exit 0
				fi
				countdown=$((coutdown+1))
			fi
	done
        countw=$((countw+1))
    	echo ":>> Enviados a executar: " $countw
done