# Bash_madMAx43v3r_chia -Beta V 2.0

- Requerimientos:
  - https://github.com/madMAx43v3r/chia-plotter
  - Ubuntu/linux
  - https://github.com/Chia-Network/chia-blockchain/wiki/INSTALL#install-from-source
  - vscode o cualquier editor para los parametros

> Ejecucion:
  

    Editar  
        Directorio madMAx43v3r instalado
        cd /home/chi/chia-plotter/build/
        Directorio para memoria ram en caso de utilizarlo verificar permisos de escritura
        ramd="/ram/"	
        declare -a tplots=('/media/chi/1/' '/media/chi/2/' '/media/chi/3/' '/media/chi/4/');  #Unidades para plottear ejemplo: ('/dir/1/') o ('/dir/1/' '/dir/2/')
        declare -a dds=('/media/chi/d6-1/' '/media/chi/d6-2/') #Unidades para Destino de plots ejemplo: ('/dir/1/') o ('/dir/1/' '/dir/2/')
        #Maximo espacio en disco a utilizar
        ddmax=80
        #Datos de <poolkey> y <farmerkey>
        poolc="xch1klvjuh4gm0t9f0305xzznf3a86s2wa4ud89mzru65nh523glq5fsfnxmv8" 
        fpool=""
        maxtplot=2 #Maximos plots por unidad, calculados a k32 depende del almacenamiento temporal ~220 GiB. Se recomienda 1 por unidad
        maxplot=8 #Numero de plots al mismo tiempo global depende del almacenamiento temporal -1
        fexit=20 #Intentos maximos para buscar destino de plots con espacio para almacenar  
Donaciones
xch1klvjuh4gm0t9f0305xzznf3a86s2wa4ud89mzru65nh523glq5fsfnxmv8 
