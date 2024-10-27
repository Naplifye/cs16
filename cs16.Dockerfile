# Use SteamCMD Docker image
FROM cm2network/steamcmd:latest

# Set environment variables for the server
ENV steamappdir=/home/steam/cs16
ENV steamappid=90

# Create directory for cs16
RUN mkdir -p ${steamappdir}

# Install the Counter-Strike 1.6 server
RUN until /home/steam/steamcmd/steamcmd.sh \
+force_install_dir ${steamappdir} \
+login anonymous \
+app_set_config ${steamappid} mod cstrike \
+app_update ${steamappid} -beta steam_legacy validate \
+quit; do \
sleep 5; \
done 

# Fix files for metamod
RUN sed -i 's|gamedll_linux "dlls/cs_i386.so"|gamedll_linux "addons/metamod/dlls/metamod_i386.so"|' ${steamappdir}/cstrike/liblist.gam

# Expose ports for server connection (default ports)
EXPOSE 27015/udp 27015/tcp

# Set the working directory
WORKDIR ${steamappdir}

# Command to start the CS 1.6 server
CMD ["./hlds_run", "-game", "cstrike", "-console", "-port", "27015", "+maxplayers", "32", "+map", "de_dust2"]