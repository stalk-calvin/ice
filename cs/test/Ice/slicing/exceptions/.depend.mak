generated/Test.cs: ./Test.ice "$(SLICE2CS)" "$(SLICEPARSERLIB)"
generated/ServerPrivate.cs: ./ServerPrivate.ice ./Test.ice "$(SLICE2CS)" "$(SLICEPARSERLIB)"
generated/TestAMD.cs: ./TestAMD.ice "$(SLICE2CS)" "$(SLICEPARSERLIB)"
generated/ServerPrivateAMD.cs: ./ServerPrivateAMD.ice ./TestAMD.ice "$(SLICE2CS)" "$(SLICEPARSERLIB)"
