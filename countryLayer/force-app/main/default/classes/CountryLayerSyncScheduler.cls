public class CountryLayerSyncScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new CountryLayerSyncQueueable());
    }
}
/*
 ran from anonymous
 CountryLayerSyncScheduler srv = new CountryLayerSyncScheduler();
 String sch = '0 0 12 * * ?';
 String jobID = System.schedule('Sync Country Job', sch, srv);
*/