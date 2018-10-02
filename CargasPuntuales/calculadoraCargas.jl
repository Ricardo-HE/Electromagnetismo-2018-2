# Para jalar los datos de un archivo
ile = open("Datos.txt")
noCargas = parse(Int,readline(file))

cargas = Array{Float64}(undef, noCargas)
coordenadas = Array{Float64}(undef, noCargas, 2)
k = 9.0e9

for i=1:noCargas
    cargas[i] = parse(Float64,readline(file))
    coordenadas[i,1] = parse(Float64, readline(file))
    coordenadas[i,2] = parse(Float64, readline(file))
end
close(file)

#=
# Este bloque de codigo es para pedir datos desde consola

# Se piden el número de cargas que tendrá el sistema
println("¿Ingrese el número de cargas?")
noCargas = parse(Int,readline())

#Se inicializan las variables que se usarán
cargas = Array{Float64}(undef, noCargas)
coordenadas = Array{Float64}(undef, noCargas, 2)
k = 9.0e9

for i = 1:noCargas
    print("Carga de la carga no.$i(Coulomb):")
    cargas[i] = parse(Float64,readline())
    print("coordenada X de la carga:")
    coordenadas[i,1] = parse(Float64, readline())
    print("coordenada Y de la carga:")
    coordenadas[i,2] = parse(Float64, readline())
end
=#
fuerzaCargas = Matrix{Float64}(undef,noCargas,noCargas)

# Calcular las fuerzas de cada una carga con todas las demas
# Se guardaran en la diagonal superior derecha de una matriz
for i = 1:noCargas
    for j = i+1:noCargas
        radio = sqrt((coordenadas[j,1] - coordenadas[i,1])^2 + (coordenadas[j,2] - coordenadas[i,2])^2)
        fuerzaCargas[i,j] = abs(k*cargas[i]*cargas[j]/radio^2)
    end
end

display("text/plain", fuerzaCargas)
println()
sumaFuerzasX = zeros(noCargas)
sumaFuerzasY = zeros(noCargas)
fuerzasTotales = zeros(noCargas)
angulosFuerza = zeros(noCargas)
for i = 1:noCargas
    # Primero se suman las columnas de la carga en la matriz de fuerzas
    for j = 1:noCargas
        # calcula el angulo de la carga i respecto a la carga j
        angulo = atan(coordenadas[j,2]-coordenadas[i,2], coordenadas[j,1]-coordenadas[i,1])

        if j < i
            # sumar fuerzas en el eje X
            if (coordenadas[i,1] > coordenadas[j,1] && cargas[i]*cargas[j] < 0) || (coordenadas[i,1] < coordenadas[j,1] && cargas[i]*cargas[j] > 0)
                sumaFuerzasX[i] -= fuerzaCargas[j,i]*abs(cos(angulo))
            elseif (coordenadas[i,1] > coordenadas[j,1] && cargas[i]*cargas[j] > 0) || (coordenadas[i,1] < coordenadas[j,1] && cargas[i]*cargas[j] < 0)
                sumaFuerzasX[i] += fuerzaCargas[j,i]*abs(cos(angulo))
            end
            # sumar fuerzas en el eje Y
            if (coordenadas[i,2] > coordenadas[j,2] && cargas[i]*cargas[j] < 0) || (coordenadas[i,2] < coordenadas[j,2] && cargas[i]*cargas[j] > 0)
                sumaFuerzasY[i] -= fuerzaCargas[j,i]*abs(sin(angulo))
            elseif (coordenadas[i,2] > coordenadas[j,2] && cargas[i]*cargas[j] > 0) || (coordenadas[i,2] < coordenadas[j,2] && cargas[i]*cargas[j] < 0)
                sumaFuerzasY[i] += fuerzaCargas[j,i]*abs(sin(angulo))
            end
        else
            break
        end
    end

    for j = i+1:noCargas
        angulo = atan(coordenadas[j,2]-coordenadas[i,2], coordenadas[j,1]-coordenadas[i,1])

        # Sumar fuerzas en el eje X
        if (coordenadas[i,1] > coordenadas[j,1] && cargas[i]*cargas[j] < 0) || (coordenadas[i,1] < coordenadas[j,1] && cargas[i]*cargas[j] > 0)
            sumaFuerzasX[i] -= fuerzaCargas[i,j]*abs(cos(angulo))
        elseif (coordenadas[i,1] > coordenadas[j,1] && cargas[i]*cargas[j] > 0) || (coordenadas[i,1] < coordenadas[j,1] && cargas[i]*cargas[j] < 0)
            sumaFuerzasX[i] += fuerzaCargas[i,j]*abs(cos(angulo))
        end

        #Sumar fuerzas en el eje Y
        if (coordenadas[i,2] > coordenadas[j,2] && cargas[i]*cargas[j] < 0) || (coordenadas[i,2] < coordenadas[j,2] && cargas[i]*cargas[j] > 0)
            sumaFuerzasY[i] -= fuerzaCargas[i,j]*abs(sin(angulo))
        elseif (coordenadas[i,] > coordenadas[j,2] && cargas[i]*cargas[j] > 0) || (coordenadas[i,2] < coordenadas[j,2] && cargas[i]*cargas[j] < 0)
            sumaFuerzasY[i] += fuerzaCargas[i,j]*abs(sin(angulo))
        end
    end

    fuerzasTotales[i] = sqrt(sumaFuerzasX[i]^2 + sumaFuerzasY[i]^2)
    angulosFuerza[i] = atand(sumaFuerzasY[i], sumaFuerzasX[i])
end

println("Fuerzas: ")
display("text/plain", fuerzasTotales)
println("\n\nAngulos de las direcciones: ")
display("text/plain", angulosFuerza)
println()
#=
    GRAFICAR
=#


using Plots
pyplot(leg=false, size=(900,500))

n = noCargas
y = coordenadas[:,2]
x = coordenadas[:,1]
vx, vy = sumaFuerzasX, sumaFuerzasY

fn = quiver(x,y, quiver=(vx,vy))
savefig("figure1")

