library(calibrate)
library(diagram)
par(mar = c(1,1,1,1))
openplotmat()
elpos <- coordinates(c(1,2,4,2,4))
fromto <- matrix(ncol = 2, byrow = T,
                 data = c(1,2,
                          1,3,
                          2,4,
                          2,5,
                          4,8,
                          5,8,
                          8,10,
                          8,11))
nr <- nrow(fromto)
arrpos <- matrix(ncol = 2, nrow = nr)
for (i in 1:nr)
  arrpos[i, ] <- straightarrow (to = elpos[fromto[i, 2], ],
                                from = elpos[fromto[i, 1], ],
                                lwd = 2, arr.pos = 0.6, arr.length = 0.5)

textdiamond(elpos[1, ],
         radx = 0.25,
         rady = 0.08,
         lab = expression(paste('range(l)=[',k[min],k[max],']')),
         box.col = "white",
         cex = 1.5)

textdiamond(elpos[2, ],
         radx = 0.25,
         rady = 0.08,
         lab = expression(paste('average(l)','>=',(k[min]+k[max])/2)),
         box.col = "white",
         cex = 1.5)

textrect(elpos[3, ],
         radx = 0.15,
         rady = 0.06,
         lab = expression(paste('[',k[min],k[max],']=range(l)')),
         box.col = "white",
         cex = 1.5)

textrect(elpos[4, ],
         radx = 0.12,
         rady = 0.06,
         lab = expression(paste(k[max],'=min{',k[max]+1,',[(n-k)/k]}')),
         box.col = "white",
         cex = 1.5)

textrect(elpos[5, ],
         radx = 0.1,
         rady = 0.06,
         lab = expression(paste(k[min],'=max{',k[min]-1,',1}')),
         box.col = "white",
         cex = 1.5)

textdiamond(elpos[8, ],
            radx = 0.25,
            rady = 0.08,
            lab = 'get l*, range(l*)=range(l)',
            box.col = "white",
            cex = 1.5)

textrect(elpos[10, ],
         radx = 0.1,
         rady = 0.06,
         lab = 'break return range(l)',
         box.col = "white",
         cex = 1.5)

textrect(elpos[11, ],
         radx = 0.1,
         rady = 0.06,
         lab = expression(paste('[',k[min],k[max],']=range(l*)')),
         box.col = "white",
         cex = 1.5)
