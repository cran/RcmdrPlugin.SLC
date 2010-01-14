# Some Rcmdr dialogs for the SLC package

.First.lib <- function(libname, pkgname){
    if (!interactive()) return()
    Rcmdr <- options()$Rcmdr
    plugins <- Rcmdr$plugins
    if ((!pkgname %in% plugins) && !getRcmdr("autoRestart")) {
        Rcmdr$plugins <- c(plugins, pkgname)
        options(Rcmdr=Rcmdr)
        closeCommander(ask=FALSE, ask.save=TRUE)
        Commander()
        }
    }

Rcmdr.slcestimates <- function(){
require(SLC)
require(tcltk)

getfile <- function() {

        command <- "tclvalue(tkgetOpenFile(filetypes='{{Text files} {.txt}} 
                {{Data files} {.dat}} {{All files} *}'))"
        assign("namefile", justDoIt(command), envir=.GlobalEnv)
        if (namefile == "") return();
        assign("datafile", justDoIt("scan(namefile)"), envir=.GlobalEnv)
}

initializeDialog(title=gettextRcmdr("Slope and Level Change Estimates"))
lengthVar <- tclVar("1")
lengthEntry <- tkentry(top, width="12", textvariable=lengthVar)

onOK <- function(){
	closeDialog()

        if (is.numeric(datafile) == FALSE){
           errorCondition(recall=Rcmdr.slcestimates, message="Invalid Data Type: Original data must be numeric.")
            return()
            }

        command <- paste("as.numeric(",tclvalue(lengthVar),")", sep="")
        assign("length.baseline", justDoIt(command), envir=.GlobalEnv)
        if ( (is.numeric(length.baseline) == FALSE) | (length.baseline < 1) ) {
            errorCondition(recall=Rcmdr.slcestimates, message="The length of baseline phase must be greater than 0.")
            return()
            }
	tkfocus(CommanderWindow())

        doItAndPrint("slcestimates(datafile,length.baseline)")      
	tkfocus(CommanderWindow())
}

OKCancelHelp(helpSubject="slcestimates")
tkgrid(labelRcmdr(top, text=""))
tkgrid(labelRcmdr(top, text=gettextRcmdr(" - Original Data should be loaded before OK - "), fg="blue"))
tkgrid(labelRcmdr(top, text=""))
tkgrid(tkbutton(top, text="Select Data File", command=getfile))
tkgrid(labelRcmdr(top, text=""))
tkgrid(labelRcmdr(top, text=gettextRcmdr(" - Baseline Phase Length Specification - "), fg="blue"),sticky="e")
tkgrid(labelRcmdr(top, text=""))
tkgrid(tklabel(top, text="Baseline Phase Length:"), lengthEntry)
tkgrid(labelRcmdr(top, text=""))
tkgrid(buttonsFrame, sticky="e", columnspan=2)
tkgrid.configure(lengthEntry, sticky="e")
dialogSuffix(rows=13, columns=2)
}

Rcmdr.help.SLC <- function(){
   require(SLC)
   doItAndPrint("help(\"SLC\")")
   invisible(NULL)
}

Rcmdr.help.RcmdrPlugin.SLC <- function(){
   require(SLC)
   doItAndPrint("help(\"RcmdrPlugin.SLC\")")
   invisible(NULL)
}

