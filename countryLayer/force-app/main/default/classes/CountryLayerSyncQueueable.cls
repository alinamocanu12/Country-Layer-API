public class CountryLayerSyncQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        CountryLayerSrv.updateCountries();
    }
}